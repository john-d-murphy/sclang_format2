use crate::engine::ast::{blanks_before, contains_comment};
use crate::engine::ast_utils::is_top_level_node;
use crate::engine::layout::{LineCursor, columns};
use crate::engine::{Ctx, TextEdit};
use crate::rules::ast_indent::line_depth;
use crate::rules::block_layout::line_can_take_brace;
use crate::rules::compact_collections::{get_elements, is_literal_ish_node};
use crate::rules::if_trailing::IfWithBlocks;
use crate::rules::width::{is_too_wide, text_end_of_line};
use crate::rules::{
    ExpandLongIfTrailingClosures, MultiLineArrayElementsPerLine, MultiLineEventsOnePerLine, Rule,
};
use anyhow::Result;
use tree_sitter::Node;

/// Breaks a line that is too wide, and then the lines that leaves, until
/// every line fits or nothing on a wide line can be broken.
///
/// What can be broken, in the order it is preferred:
///
/// 1. A block that stands on the line is opened: what it takes stays on
///    the brace's line, and each statement of its body gets a line. An
///    `if` with two blocks is parted as `ExpandLongIfTrailingClosures`
///    parts it, by that rule, which is run from here.
/// 2. What stands between a call's parentheses, or those of an `if`, a
///    `while` or a `for`, or those that group an expression, goes on a line
///    of its own, and the closing one on the line after. Arguments that are
///    too wide on that line get a line each. An event is opened the same
///    way, and an array that `CompactShortCollections` would not join
///    again; the rules for those give each of their elements a line.
/// 3. A chain of binary operators or keyword messages that begins a line
///    between such parentheses breaks before each of its operators.
///
/// On a line the outermost such thing is broken, since the ones it holds
/// move to lines of their own with it; a block passed as an argument
/// stands as high as the parentheses it is passed in (`foo(a, { |x|`). Of
/// two that stand side by side the preferred kind wins; of two of a kind,
/// one that leaves the line it begins on no wider than it may be, then the
/// one that takes more off the line, then the last.
///
/// Nothing is joined, and no token moves but to another line. What holds a
/// comment is left as it is (see `contains_comment`), and so is a line that
/// is too wide only with the comment that ends it. A break that would not
/// make its line narrower is not made.
pub struct BreakWideLines;

impl Rule for BreakWideLines {
    fn name(&self) -> &'static str {
        "break_wide_lines"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let mut total = 0;
        loop {
            // The breaks of a round, and then the ifs: one that stands in
            // something broken this round is measured on the line that
            // leaves it.
            let breaks = collect(cx);
            let made =
                make(cx, breaks)? + attach_braces(cx)? + ExpandLongIfTrailingClosures.run(cx)?;
            if made == 0 {
                return Ok(total);
            }
            total += made;
            // A break may leave an array or an event standing over several
            // lines, which the rules before this one lay out.
            MultiLineEventsOnePerLine.run(cx)?;
            MultiLineArrayElementsPerLine.run(cx)?;
        }
    }
}

/// Makes the breaks; how many were made.
fn make(cx: &mut Ctx, breaks: Vec<Vec<TextEdit>>) -> Result<usize> {
    if cx.apply_edits_that_keep_the_tree(breaks.concat())? {
        return Ok(breaks.len());
    }
    // One of them changes what the text parses to, or there were none. The
    // others are made one at a time, the last first, so that each is still
    // where it was found.
    let mut made = 0;
    for edits in breaks.into_iter().rev() {
        made += usize::from(cx.apply_edits_that_keep_the_tree(edits)?);
    }
    Ok(made)
}

/// Takes a brace that stands alone on its line up to the line before it,
/// where `block_layout_kandr` would on the next pass: after a line that can
/// take a brace, and after a closing brace alone on its line at the same
/// depth. A block that began its line leaves its brace so when it is
/// opened, and that rule ran before this one.
fn attach_braces(cx: &mut Ctx) -> Result<usize> {
    let bytes = cx.bytes();
    let root = cx.tree.root_node();
    let is_token = |at: usize, kind: &str| {
        root.descendant_for_byte_range(at, at + 1)
            .is_some_and(|n| n.kind() == kind)
    };
    let lines: Vec<_> = LineCursor::new(bytes).collect();
    let mut edits = Vec::new();
    for pair in lines.windows(2) {
        let (above, line) = (&pair[0], &pair[1]);
        let (closing, brace) = (above.first_non_ws, line.first_non_ws);
        if bytes[brace..line.end].trim_ascii_end() != b"{" || !is_token(brace, "{") {
            continue;
        }
        let above_text = bytes[closing..above.end].trim_ascii_end();
        let chained = above_text == b"}"
            && is_token(closing, "}")
            && line_depth(root, bytes, closing) == line_depth(root, bytes, brace);
        if chained || line_can_take_brace(root, &bytes[above.start..above.end], above.start) {
            edits.push(TextEdit {
                start_byte: closing + above_text.len(),
                end_byte: brace,
                replacement: " ".to_string(),
            });
        }
    }
    let n = edits.len();
    Ok(if cx.apply_edits_that_keep_the_tree(edits)? {
        n
    } else {
        0
    })
}

/// The text of a line that is too wide: from its first character that is
/// not a blank to the end of its code.
struct WideLine {
    start: usize,
    end: usize,
}

/// A thing that can be broken, by the order of preference.
#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
enum Kind {
    Block,
    Brackets,
    Arguments,
    Chain,
}

struct Break {
    kind: Kind,
    /// Where the line it is made on will end.
    line_end: usize,
    /// How many bytes it takes off that line, to lines of their own.
    takes: usize,
    edits: Vec<TextEdit>,
}

/// For each line that is too wide and can be broken, the break to make on
/// it, in the order of the text.
fn collect(cx: &Ctx) -> Vec<Vec<TextEdit>> {
    let bytes = cx.bytes();
    let lines: Vec<WideLine> = LineCursor::new(bytes)
        .filter_map(|line| {
            let start = line.first_non_ws;
            let end = code_end(cx, start, text_end_of_line(cx, start));
            (end > start && is_too_wide(cx, start, &[&bytes[start..end]]))
                .then_some(WideLine { start, end })
        })
        .collect();
    if lines.is_empty() {
        return Vec::new();
    }
    let mut found = Finder {
        cx,
        best: lines.iter().map(|_| None).collect(),
        lines,
    };
    found.visit(cx.tree.root_node());
    found
        .best
        .into_iter()
        .flatten()
        .map(|found| found.edits)
        // An `if` with two blocks is its own rule's to part.
        .filter(|edits| !edits.is_empty())
        .collect()
}

/// Where the code of the line that begins at `start` ends: before the
/// comment that ends the line, when one does. That comment is left where
/// it is, and no break of the code before it would make it shorter.
fn code_end(cx: &Ctx, start: usize, mut end: usize) -> usize {
    while end > start {
        let last = cx.tree.root_node().descendant_for_byte_range(end - 1, end);
        let Some(comment) = last.filter(|n| {
            matches!(n.kind(), "line_comment" | "block_comment") && n.start_byte() >= start
        }) else {
            break;
        };
        end = blanks_before(cx.bytes(), comment);
    }
    end
}

/// The nodes that take arguments between parentheses, which are opened,
/// and indented when they are (see `block_depth_at`).
const WITH_PARENTHESES: [&str; 8] = [
    "function_call",
    "method_call",
    "apply_call",
    "instance_variable_setter_call",
    "if",
    "while",
    "for",
    "forby",
];

/// Whether `node` is parentheses that group an expression. Those that wrap
/// a whole region of a file are not: what they hold is not indented.
fn groups(node: Node) -> bool {
    node.kind() == "code_block" && !is_top_level_node(node)
}

/// The kinds of the brackets of `node` that are opened like an argument
/// list, when it has such.
fn brackets_of(node: Node) -> Option<(&'static str, &'static str)> {
    match node.kind() {
        kind if WITH_PARENTHESES.contains(&kind) => Some(("(", ")")),
        "code_block" if groups(node) => Some(("(", ")")),
        "event" => Some(("(", ")")),
        // An array of plain things is joined into one line again by
        // `CompactShortCollections` whenever its line is not too wide with
        // it, and what else is broken on that line may make it so: such an
        // array is left to that rule.
        "collection" if !get_elements(node).into_iter().all(is_literal_ish_node) => {
            Some(("[", "]"))
        }
        _ => None,
    }
}

/// What wraps an argument between a call's parentheses.
const ARGUMENT_WRAPPERS: [&str; 3] = ["unnamed_argument", "argument_calls", "parameter_call_list"];

/// Walks the tree for what can be broken on the wide lines, and keeps the
/// best for each.
struct Finder<'a> {
    cx: &'a Ctx,
    lines: Vec<WideLine>,
    best: Vec<Option<Break>>,
}

impl Finder<'_> {
    /// The wide line that holds all of `start..end`.
    fn line_of(&self, start: usize, end: usize) -> Option<usize> {
        let i = self.lines.partition_point(|line| line.end <= start);
        self.lines
            .get(i)
            .is_some_and(|line| line.start <= start && end <= line.end)
            .then_some(i)
    }

    fn visit(&mut self, node: Node) {
        // Nothing to find where no wide line is.
        let i = self
            .lines
            .partition_point(|line| line.end <= node.start_byte());
        if self
            .lines
            .get(i)
            .is_none_or(|line| line.start >= node.end_byte())
        {
            return;
        }
        let found = match node.kind() {
            "if" => self.if_with_blocks(node),
            "function_block" => self.block(node),
            "parameter_call_list" => self.arguments(node),
            "binary_expression" => self.chain(node),
            _ => false,
        };
        if found {
            // What it holds is not as far out as it is.
            return;
        }
        let between = self.brackets(node);
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            let inside = between
                .is_some_and(|(from, to)| from <= child.start_byte() && child.end_byte() <= to);
            if !inside {
                self.visit(child);
            }
        }
    }

    /// Takes `found` for line `line` when it is better than what the line
    /// has.
    fn offer(&mut self, line: usize, found: Break) {
        let start = self.lines[line].start;
        let fits = |b: &Break| !is_too_wide(self.cx, start, &[&self.cx.bytes()[start..b.line_end]]);
        let better = self.best[line].as_ref().is_none_or(|best| {
            (found.kind, !fits(&found), best.takes, best.line_end)
                < (best.kind, !fits(best), found.takes, found.line_end)
        });
        if better {
            self.best[line] = Some(found);
        }
    }

    /// Whether a line of `inner`, one level in, is narrower than `line` is:
    /// only then is breaking it out of the line worth a line.
    fn is_narrower(&self, inner: &[u8], line: usize) -> bool {
        let style = self.cx.indent_style;
        let line = &self.lines[line];
        style.width() + columns(inner, style)
            < columns(&self.cx.bytes()[line.start..line.end], style)
    }

    /// A line break in place of the blanks before `node`.
    fn break_before(&self, node: Node) -> TextEdit {
        TextEdit {
            start_byte: blanks_before(self.cx.bytes(), node),
            end_byte: node.start_byte(),
            replacement: "\n".to_string(),
        }
    }

    /// An `if` with two blocks on a wide line is parted by the rule that
    /// parts one, once this round's breaks are made. It is offered as a
    /// block with nothing to do, so that nothing else on its line is broken
    /// in its place, and nothing it holds.
    fn if_with_blocks(&mut self, node: Node) -> bool {
        let then_block = node.child(node.child_count().saturating_sub(2));
        let (Some(line), Some(then_block), Some(_)) = (
            self.line_of(node.start_byte(), node.end_byte()),
            then_block,
            IfWithBlocks::read(node, self.cx.bytes()),
        ) else {
            return false;
        };
        self.offer(
            line,
            Break {
                kind: Kind::Block,
                line_end: then_block.start_byte() + 1,
                takes: node.end_byte() - then_block.start_byte(),
                edits: Vec::new(),
            },
        );
        true
    }

    /// A block that stands on a wide line is opened:
    ///
    /// ```text
    /// { |a| b; c }      { |a|
    ///                       b;
    ///                       c
    ///                   }
    /// ```
    fn block(&mut self, block: Node) -> bool {
        let Some(line) = self.line_of(block.start_byte(), block.end_byte()) else {
            return false;
        };
        let mut cursor = block.walk();
        let children: Vec<Node> = block.children(&mut cursor).collect();
        let (Some(open), Some(close)) = (
            children.iter().position(|n| n.kind() == "{"),
            children.iter().rposition(|n| n.kind() == "}"),
        ) else {
            return false;
        };
        // What the block takes stays on the brace's line.
        let head = children[open + 1..close]
            .iter()
            .take_while(|n| n.kind() == "parameter_list")
            .count();
        let statements: Vec<Node> = children[open + 1 + head..close]
            .iter()
            .copied()
            .filter(|n| n.kind() != ";")
            .collect();
        if contains_comment(block) {
            // Left as it is, with all it holds.
            return true;
        }
        let Some(first) = statements.first() else {
            return false;
        };
        let body = &self.cx.bytes()[first.start_byte()..children[close - 1].end_byte()];
        if !self.is_narrower(body, line) {
            return false;
        }
        let edits = statements
            .iter()
            .chain([&children[close]])
            .map(|n| self.break_before(*n))
            .collect();
        self.offer(
            line,
            Break {
                kind: Kind::Block,
                line_end: children[open + head].end_byte(),
                takes: body.len(),
                edits,
            },
        );
        true
    }

    /// What stands between the brackets of `node` on a wide line goes on a
    /// line of its own:
    ///
    /// ```text
    /// foo(a, b).c      foo(
    ///                      a, b
    ///                  ).c
    /// ```
    ///
    /// A block passed between parentheses is offered beside them, to be
    /// opened in their place. Where the brackets are to be opened: the
    /// bytes between them, in which nothing else is looked for.
    fn brackets(&mut self, node: Node) -> Option<(usize, usize)> {
        let (opening, closing) = brackets_of(node)?;
        let mut cursor = node.walk();
        let children: Vec<Node> = node.children(&mut cursor).collect();
        let open = children.iter().position(|n| n.kind() == opening)?;
        let close = open + children[open..].iter().position(|n| n.kind() == closing)?;
        let (first, last) = (children.get(open + 1)?, children[close - 1]);
        let line = self.line_of(children[open].start_byte(), children[close].end_byte())?;
        if close == open + 1 {
            return None;
        }
        let inner = (first.start_byte(), last.end_byte());
        if children[open + 1..close]
            .iter()
            .any(|n| contains_comment(*n))
        {
            // Left as it is, with all it holds.
            return Some(inner);
        }
        if WITH_PARENTHESES.contains(&node.kind()) {
            for block in children[open + 1..close]
                .iter()
                .flat_map(|n| blocks_passed(*n))
            {
                self.block(block);
            }
        }
        // The widest of what stands between them: when all of it is too
        // wide for the line it gets, each gets a line.
        let narrower = children[open + 1..close]
            .iter()
            .flat_map(|n| arguments_of(*n))
            .all(|n| self.is_narrower(&self.cx.bytes()[n.byte_range()], line));
        if !narrower {
            return None;
        }
        let edits = vec![
            self.break_before(*first),
            self.break_before(children[close]),
        ];
        self.offer(
            line,
            Break {
                kind: Kind::Brackets,
                line_end: children[open].end_byte(),
                takes: inner.1 - inner.0,
                edits,
            },
        );
        Some(inner)
    }

    /// Arguments that are too wide on the line they have to themselves get
    /// a line each:
    ///
    /// ```text
    /// foo(             foo(
    ///     a, b             a,
    /// )                    b
    ///                  )
    /// ```
    fn arguments(&mut self, list: Node) -> bool {
        let Some(line) = self.line_of(list.start_byte(), list.end_byte()) else {
            return false;
        };
        let to_itself = self.lines[line].start == list.start_byte()
            && list.prev_sibling().is_some_and(|n| {
                n.kind() == "(" && n.end_position().row < list.start_position().row
            })
            && list.next_sibling().is_some_and(|n| {
                n.kind() == ")" && n.start_position().row > list.end_position().row
            });
        if !to_itself {
            return false;
        }
        if contains_comment(list) {
            // Left as it is, with all it holds.
            return true;
        }
        let mut cursor = list.walk();
        let edits: Vec<TextEdit> = list
            .children(&mut cursor)
            .filter(|n| n.kind() == ",")
            .filter_map(|comma| comma.next_sibling())
            .map(|argument| self.break_before(argument))
            .collect();
        if edits.is_empty() {
            return false;
        }
        self.offer(
            line,
            Break {
                kind: Kind::Arguments,
                line_end: edits[0].start_byte,
                takes: 0,
                edits,
            },
        );
        true
    }

    /// A chain of binary operators that begins a wide line between
    /// parentheses that are opened breaks before each operator:
    ///
    /// ```text
    /// if (                  if (
    ///     a and: b or: c        a
    /// ) { d }                   and: b
    ///                           or: c
    ///                       ) { d }
    /// ```
    ///
    /// sclang has no precedence among binary operators, and the tree nests
    /// them any way: the chain is every operator of the binary expressions
    /// that stand straight under one another. A chain with an assignment in
    /// it is left as it is.
    fn chain(&mut self, chain: Node) -> bool {
        let is_binary = |n: Node| n.kind() == "binary_expression";
        if chain.parent().is_some_and(is_binary) {
            return false;
        }
        let Some(line) = self.line_of(chain.start_byte(), chain.end_byte()) else {
            return false;
        };
        // The parentheses the chain stands between, when they are opened:
        // nothing follows the opening one on its line.
        let opened = std::iter::successors(chain.parent(), Node::parent)
            .find(|n| !ARGUMENT_WRAPPERS.contains(&n.kind()))
            .filter(|n| WITH_PARENTHESES.contains(&n.kind()) || groups(*n))
            .and_then(|n| {
                let mut cursor = n.walk();
                n.children(&mut cursor).find(|n| n.kind() == "(")
            })
            .and_then(|open| {
                Some(open.end_position().row < open.next_sibling()?.start_position().row)
            });
        if self.lines[line].start != chain.start_byte() || opened != Some(true) {
            return false;
        }
        if contains_comment(chain) {
            // Left as it is, with all it holds.
            return true;
        }
        let mut operators = Vec::new();
        let mut pending = vec![chain];
        while let Some(node) = pending.pop() {
            operators.extend(node.child_by_field_name("operator"));
            for side in ["left", "right"] {
                pending.extend(node.child_by_field_name(side).filter(|n| is_binary(*n)));
            }
        }
        operators.sort_by_key(Node::start_byte);
        // An operator with no blank before it is left on its line.
        let edits: Vec<TextEdit> = operators
            .iter()
            .map(|operator| self.break_before(*operator))
            .filter(|edit| edit.start_byte < edit.end_byte)
            .collect();
        if edits.is_empty() || operators.iter().any(|n| n.kind() == "=") {
            return false;
        }
        self.offer(
            line,
            Break {
                kind: Kind::Chain,
                line_end: edits[0].start_byte,
                takes: 0,
                edits,
            },
        );
        true
    }
}

/// The arguments in `node`, which stands between a pair of brackets:
/// itself, or the arguments of the list it is. A comma is none.
fn arguments_of(node: Node) -> Vec<Node> {
    let mut cursor = node.walk();
    match node.kind() {
        "," => Vec::new(),
        "parameter_call_list" => node
            .children(&mut cursor)
            .filter(|n| n.kind() == "argument_calls")
            .collect(),
        _ => vec![node],
    }
}

/// The blocks passed as arguments in `node`, which stands between a pair
/// of parentheses: the values of its arguments that are blocks.
fn blocks_passed(node: Node) -> Vec<Node> {
    arguments_of(node)
        .into_iter()
        .filter_map(|n| match n.kind() {
            // The argument, named or not, and in it its value.
            "argument_calls" => n.child(0).and_then(|n| n.child(n.child_count() - 1)),
            _ => Some(n),
        })
        .filter(|n| n.kind() == "function_block")
        .collect()
}

#[cfg(test)]
mod tests {
    use crate::format_source;

    /// `src` formatted by every rule, so that the lines this rule makes are
    /// seen with the indent they get, after checking that a second pass
    /// changes nothing.
    fn format(src: &str) -> String {
        let once = format_source(src).unwrap();
        assert_eq!(format_source(&once).unwrap(), once, "a second pass");
        once
    }

    #[test]
    fn test_a_line_of_80_is_left_and_one_of_81_is_broken() {
        let src = format!("x = foo({});\n", "a".repeat(70));
        assert_eq!(src.trim_end().len(), 80);
        assert_eq!(format(&src), src);
        let wide = "a".repeat(71);
        assert_eq!(
            format(&format!("x = foo({wide});\n")),
            format!("x = foo(\n    {wide}\n);\n")
        );
    }

    #[test]
    fn test_a_block_is_opened_and_each_statement_gets_a_line() {
        assert_eq!(
            format(
                "list.do { |item| var doubled = item * 2; doubled.postln; results.add(doubled + offsetForTheResults) };\n"
            ),
            "list.do { |item|\n    var doubled = item * 2;\n    doubled.postln;\n    results.add(doubled + offsetForTheResults)\n};\n"
        );
        // A function that is assigned, and the body of a method.
        assert_eq!(
            format(
                "f = { |a, b| a.someMethod(b) + b.someOtherMethod(a) + a.yetAnotherMethodToCall(b, 1) + 1 };\n"
            ),
            "f = { |a, b|\n    a.someMethod(b) + b.someOtherMethod(a) + a.yetAnotherMethodToCall(b, 1) + 1\n};\n"
        );
        assert_eq!(
            format(
                "Foo {\n    bar { |a, b| ^this.someMethod(a) + this.someOtherMethod(b) + this.yetAnother(a, b) }\n}\n"
            ),
            "Foo {\n    bar { |a, b|\n        ^this.someMethod(a) + this.someOtherMethod(b) + this.yetAnother(a, b)\n    }\n}\n"
        );
    }

    #[test]
    fn test_a_block_that_is_passed_is_opened_before_the_parentheses_it_is_in() {
        assert_eq!(
            format(
                "SystemClock.sched(0.5, { |time| thisProcess.interpreter.executeFile(pathOfTheFileToRun); nil });\n"
            ),
            "SystemClock.sched(0.5, { |time|\n    thisProcess.interpreter.executeFile(pathOfTheFileToRun);\n    nil\n});\n"
        );
    }

    #[test]
    fn test_of_two_blocks_the_last_is_opened_and_the_first_when_that_is_not_enough() {
        assert_eq!(
            format(
                "x.either({ aaaaaaaa.bbbbbbbb(cccccccc, dddddddd) }, { eeeeeeee.ffffffff(gggggggg, hhhhhhhh) });\n"
            ),
            "x.either({ aaaaaaaa.bbbbbbbb(cccccccc, dddddddd) }, {\n    eeeeeeee.ffffffff(gggggggg, hhhhhhhh)\n});\n"
        );
        let (a, b) = ("a".repeat(76), "b".repeat(76));
        assert_eq!(
            format(&format!("x.either({{ {a} }}, {{ {b} }});\n")),
            format!("x.either({{\n    {a}\n}}, {{\n    {b}\n}});\n")
        );
    }

    #[test]
    fn test_arguments_go_on_a_line_of_their_own_and_then_on_one_each() {
        assert_eq!(
            format(
                "x = aCallOfSomeLength(firstArgument, secondArgument).another(thirdArgument, fourthArgument);\n"
            ),
            "x = aCallOfSomeLength(firstArgument, secondArgument).another(\n    thirdArgument, fourthArgument\n);\n"
        );
        assert_eq!(
            format(
                "x = someFunction(firstArgumentOfAll, secondArgumentOfAll, thirdArgumentOfAll, fourthArgumentOfAll, fifthArgumentOfAll);\n"
            ),
            "x = someFunction(\n    firstArgumentOfAll,\n    secondArgumentOfAll,\n    thirdArgumentOfAll,\n    fourthArgumentOfAll,\n    fifthArgumentOfAll\n);\n"
        );
    }

    #[test]
    fn test_of_two_calls_the_one_that_takes_more_off_the_line_is_opened() {
        assert_eq!(
            format(
                "q = StaticText(n, n.bounds.moveTo(0, 0).insetBy(25)).string_(l[i]).align_(\\center);\n"
            ),
            "q = StaticText(\n    n, n.bounds.moveTo(0, 0).insetBy(25)\n).string_(l[i]).align_(\\center);\n"
        );
    }

    #[test]
    fn test_parentheses_that_group_an_expression_are_opened_like_a_call() {
        assert_eq!(
            format(
                "x = (firstOperandOfTheChain + secondOperandOfTheChain - thirdOperandOfTheChain) * fourthOperand;\n"
            ),
            "x = (\n    firstOperandOfTheChain + secondOperandOfTheChain - thirdOperandOfTheChain\n) * fourthOperand;\n"
        );
        assert_eq!(
            format(
                "x = (firstOperandOfTheChain + secondOperandOfTheChain - thirdOperandOfTheChain + more) * fourthOperand;\n"
            ),
            "x = (\n    firstOperandOfTheChain\n    + secondOperandOfTheChain\n    - thirdOperandOfTheChain\n    + more\n) * fourthOperand;\n"
        );
        // Those that wrap a region of a file are not: its lines have no
        // indent of their own.
        let src = "(\nfirstOperandOfTheChain + secondOperandOfTheChain - thirdOperandOfTheChain * fourthOperandOfTheChain;\n)\n";
        assert_eq!(format(src), src);
    }

    #[test]
    fn test_an_array_and_an_event_are_opened_and_get_an_element_to_a_line() {
        assert_eq!(
            format(
                "x = [Color.black, Color.green(0.8), Color.white, Color.red(0.5), Color.blue(0.25), Color.yellow];\n"
            ),
            "x = [\n    Color.black,\n    Color.green(0.8),\n    Color.white,\n    Color.red(0.5),\n    Color.blue(0.25),\n    Color.yellow\n];\n"
        );
        assert_eq!(
            format(
                "x = (freq: 440, amp: 0.1, pan: 0, instrument: \\default, sustain: 1.5, legato: 0.8, stretch: 1.0);\n"
            ),
            "x = (\n    freq: 440,\n    amp: 0.1,\n    pan: 0,\n    instrument: \\default,\n    sustain: 1.5,\n    legato: 0.8,\n    stretch: 1.0\n);\n"
        );
    }

    #[test]
    fn test_an_array_of_plain_things_is_left_to_the_rule_that_joins_them() {
        // Opened, it would be one that rule joins again whenever its line
        // has room, and that is not for this rule to know.
        let src = "x = [\\alpha, \\beta, \\gamma, \\delta, \\epsilon, \\zeta, \\eta, \\theta, \\iota, \\kappa, \\lambda, \\mu];\n";
        assert_eq!(format(src), src);
    }

    #[test]
    fn test_brackets_are_opened_when_each_thing_in_them_is_narrower_than_the_line() {
        // All of it on one line would be wider than the line was, and each
        // of the two on its own is not.
        let (a, b) = ("a".repeat(40), "b".repeat(40));
        assert_eq!(
            format(&format!("f({a}, {b})\n")),
            format!("f(\n    {a},\n    {b}\n)\n")
        );
    }

    #[test]
    fn test_of_two_calls_one_whose_parenthesis_ends_a_line_that_fits_is_opened() {
        // The second call's parenthesis is past column 80: opening it would
        // leave the line as wide as it was.
        let (a, b) = ("a".repeat(35), "b".repeat(35));
        assert_eq!(
            format(&format!("x = foo({a}, {b}).bar(c);\n")),
            format!("x = foo(\n    {a}, {b}\n).bar(c);\n")
        );
    }

    #[test]
    fn test_a_chain_between_opened_parentheses_breaks_before_each_operator() {
        assert_eq!(
            format(
                "x = this.someMethod(firstOperandOfTheChain + secondOperandOfTheChain - thirdOperandOfTheChain * fourthOperand);\n"
            ),
            "x = this.someMethod(\n    firstOperandOfTheChain\n    + secondOperandOfTheChain\n    - thirdOperandOfTheChain\n    * fourthOperand\n);\n"
        );
        assert_eq!(
            format(
                "while (thisIsTheFirstCondition and: { thisIsTheSecondCondition } and: { thisIsTheThird }) { go.on };\n"
            ),
            "while (\n    thisIsTheFirstCondition\n    and: { thisIsTheSecondCondition }\n    and: { thisIsTheThird }\n) {\n    go.on\n};\n"
        );
    }

    #[test]
    fn test_a_chain_that_is_not_between_parentheses_or_holds_an_assignment_is_left() {
        let src = "x = firstOperandOfTheChain + secondOperandOfTheChain - thirdOperandOfTheChain * fourthOperandOfTheChain;\n";
        assert_eq!(format(src), src);
        assert_eq!(
            format(
                "this.someMethod(target.value = firstOperandOfTheChain + secondOperandOfTheChain + thirdOperandOfTheChain);\n"
            ),
            "this.someMethod(\n    target.value = firstOperandOfTheChain + secondOperandOfTheChain + thirdOperandOfTheChain\n);\n"
        );
    }

    #[test]
    fn test_what_cannot_be_broken_or_is_no_narrower_broken_stays_wide() {
        for src in [
            // A string, and a call that would only move it four columns in.
            "x = \"a string that is much too long for its line but cannot be broken, being a string\";\n",
            "f(\"a string that is much too long for its line but cannot be broken, being a string, at all\");\n",
            // What holds a comment.
            "x = foo(firstArgumentOfAll, /* why */ secondArgumentOfAll, thirdArgumentOfAll, fourthArgumentOfAll);\n",
            "x = { |a| a.someMethod(1) + a.someOtherMethod(2) /* why */ + a.yetAnotherMethodToCall(3) };\n",
            // A line that is too wide only with the comment that ends it.
            "x = foo(a, b);  // a comment that takes the line over eighty columns, at its end, and stays\n",
        ] {
            assert_eq!(format(src), src);
        }
    }

    #[test]
    fn test_an_if_with_two_blocks_is_parted_after_what_holds_it_is_broken() {
        // Once the block that holds it is opened, the if has a line it may
        // fit on.
        assert_eq!(
            format(
                "f = { |a| if (a.isSomething) { a.doTheFirstThing(1, 2) } { a.doTheSecondThing(3, 4) }; a.finish };\n"
            ),
            "f = { |a|\n    if (a.isSomething) { a.doTheFirstThing(1, 2) } { a.doTheSecondThing(3, 4) };\n    a.finish\n};\n"
        );
        assert_eq!(
            format(
                "f = { |a| if (a.isSomething) { a.doTheFirstThing(1, 2, 3) } { a.doTheSecondThing(4, 5, 6) }; a.finish };\n"
            ),
            "f = { |a|\n    if (a.isSomething) {\n        a.doTheFirstThing(1, 2, 3)\n    } {\n        a.doTheSecondThing(4, 5, 6)\n    };\n    a.finish\n};\n"
        );
        // Beside a call on its line, the if is what is parted.
        assert_eq!(
            format(
                "x = aCallOfSomeLength(firstArgument) + if (a.isSomething) { a.doTheFirstThing } { a.doTheSecondThing };\n"
            ),
            "x = aCallOfSomeLength(firstArgument) + if (a.isSomething) {\n    a.doTheFirstThing\n} {\n    a.doTheSecondThing\n};\n"
        );
    }

    #[test]
    fn test_an_array_a_break_leaves_over_several_lines_has_an_element_to_a_line() {
        // The array is opened, and the rule for arrays gives each element
        // a line; the block, still too wide on its own, is opened then.
        assert_eq!(
            format(
                "x = [1, 2, { |a| a.someMethod(1) + a.someOtherMethod(2) + a.yetAnotherMethodToCall(3) }, 4];\n"
            ),
            "x = [\n    1,\n    2,\n    { |a|\n        a.someMethod(1) + a.someOtherMethod(2) + a.yetAnotherMethodToCall(3)\n    },\n    4\n];\n"
        );
        // An array of plain things is not opened, and the block in it is:
        // then the array stands over several lines.
        assert_eq!(
            format(&format!(
                "x = [1, 2, 3].collect {{ |a| {} }};\n",
                "a".repeat(70)
            )),
            format!(
                "x = [1, 2, 3].collect {{ |a|\n    {}\n}};\n",
                "a".repeat(70)
            )
        );
    }

    #[test]
    fn test_a_brace_left_alone_on_its_line_goes_where_the_next_pass_would_put_it() {
        // 81 columns as a block on one line, and 80 as its body.
        let long = "a".repeat(76);
        // After a line that can take a brace, and after a closing brace
        // alone on its line.
        assert_eq!(
            format(&format!("if (aCondition)\n{{ {long} }};\n")),
            format!("if (aCondition) {{\n    {long}\n}};\n")
        );
        assert_eq!(
            format(&format!("x = case\n{{ a }} {{\n    b\n}}\n{{ {long} }};\n")),
            format!("x = case\n{{ a }} {{\n    b\n}} {{\n    {long}\n}};\n")
        );
        // After any other line it stays.
        assert_eq!(
            format(&format!("x = case\n{{ a }} {{ b }}\n{{ {long} }};\n")),
            format!("x = case\n{{ a }} {{ b }}\n{{\n    {long}\n}};\n")
        );
    }

    #[test]
    fn test_a_tab_of_indent_is_counted_as_four_columns() {
        // 78 columns of text one level deep.
        let src = format!("f = {{\n\tx = foo({});\n}};\n", "a".repeat(68));
        let tabs =
            |src: &str| crate::format_source_with_indent(src, crate::IndentStyle::Tabs).unwrap();
        assert_eq!(
            tabs(&src),
            format!("f = {{\n\tx = foo(\n\t\t{}\n\t)\n}};\n", "a".repeat(68))
        );
    }
}
