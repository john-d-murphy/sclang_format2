use crate::engine::ast::{blanks_before, end_of_token_before, next_token};
use crate::engine::ast_utils::{
    Brackets, Depths, begins_line, brackets_of, cases_of, dots_of, is_chain, is_comment, is_region,
    operators_of,
};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::{Result, anyhow};
use tree_sitter::Node;

/// Lays code out: where its lines break is decided by the code alone.
///
/// `join_lines` has taken away the breaks the writer made inside each
/// statement; this rule makes the ones the layout wants, and
/// `indent_by_ast_level` indents the lines it leaves.
///
/// Every statement begins a line. A statement that fits in its line stands
/// on it whole. One that does not, or that holds something that is always
/// open, is broken, the outermost thing first:
///
/// 1. The declarations of a `var`, `classvar` or `const` get a line each,
///    those after the first one level in.
/// 2. A chain of operators that is the statement, or the value it assigns
///    or returns, breaks before each operator, the lines after the first
///    one level in. Where keyword messages stand among binary operators it
///    breaks before the keywords, which bind loosest, and before the others
///    only where a line is still too wide. A chain of one operator is left
///    whole when opening the brackets that end it, or that it begins with,
///    is enough.
/// 3. A pair of brackets is opened: what it holds goes one level in, and
///    the closing bracket on a line of its own. Of the pairs on a line it
///    is the last that leaves the line it begins on no wider than it may
///    be; a block that ends a line too wide is opened whatever stands
///    before it, and that is then broken in its turn. What parentheses or
///    brackets hold stands on one line when it fits there, and otherwise
///    has an item to a line (a key and its value together). An item still
///    too wide that is a chain breaks before its operators, level with its
///    first operand, as Black breaks one; then its brackets are opened.
///    The statements of a block get a line each.
///
/// A block that is the last argument of a call, and the only block among
/// the arguments, is opened in the parentheses' place when all that stands
/// before its body fits on the line. The two blocks of an `if` are opened
/// together. A `switch` keeps the value it switches on on its line, and
/// each test and its block, of a `switch` or of a `case`, gets a line.
///
/// Always open: a block of two statements or more; the body of a class; a
/// region of a file; what holds a comment (a block, a list between
/// brackets, a chain, a list of declarations) or a line break that
/// `join_lines` left (beside a comment, or in a string); a list whose last
/// item is followed by a comma.
///
/// No token is added or moved past another: only the blanks between two
/// tokens become a line break.
pub struct BreakLines;

impl Rule for BreakLines {
    fn name(&self) -> &'static str {
        "break_lines"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let (mut edits, lines) = {
            let mut layout = Layout::new(cx);
            layout.file();
            (layout.edits, layout.lines)
        };
        edits.sort_by_key(|edit| edit.start_byte);
        edits.dedup_by_key(|edit| edit.start_byte);
        let made = edits.len();
        let kept = cx.apply_edits_that_keep_the_tree(edits.clone())?;
        // A line break between two tokens changes nothing the tree holds.
        // Were one ever to, the text is left as it was, on the lines the
        // statements have: a build for tests says so.
        if cfg!(debug_assertions) {
            anyhow::ensure!(
                kept || made == 0,
                "the line breaks of the layout change what the text parses to"
            );
            check_depths(cx, &edits, &lines)?;
        }
        Ok(if kept { made } else { 0 })
    }
}

/// A build for tests checks that each line the layout made stands at the
/// depth it was measured at: `indent_by_ast_level` reads the depth from
/// the tree, and a line measured at another depth would be broken too soon
/// or left too wide.
fn check_depths(cx: &Ctx, edits: &[TextEdit], lines: &[(usize, usize)]) -> Result<()> {
    let mut lines = lines.to_vec();
    lines.sort_unstable();
    let mut depths = Depths::new(cx.bytes());
    // How far the breaks made before a line have moved where it begins.
    let (mut removed, mut added) = (0, 0);
    let mut edits = edits.iter().peekable();
    for (at, depth) in lines {
        while let Some(edit) = edits.next_if(|edit| edit.end_byte <= at) {
            removed += edit.end_byte - edit.start_byte;
            added += edit.replacement.len();
        }
        let now = at + added - removed;
        let stands = depths.at(cx.tree.root_node(), now);
        if stands != depth {
            let bytes = cx.bytes();
            let text = String::from_utf8_lossy(&bytes[now..]);
            return Err(anyhow!(
                "line {} was measured at depth {depth} and stands at {stands}: {:?}",
                bytes[..now].split(|&b| b == b'\n').count(),
                text.lines().next().unwrap_or_default()
            ));
        }
    }
    Ok(())
}

/// A pair of brackets, the node whose they are, and the first pair after
/// it that it does not hold.
#[derive(Clone, Copy)]
struct Pair<'a> {
    owner: Node<'a>,
    brackets: Brackets<'a>,
    after: usize,
}

/// The pair to open on a line.
struct Choice {
    /// The pair that is opened.
    opens: usize,
    /// The pair it was chosen for: itself, or the parentheses of the call
    /// whose last argument the opened block is.
    of: usize,
    /// Whether the line it begins on fits.
    head_fits: bool,
}

struct Layout<'a> {
    cx: &'a Ctx,
    bytes: &'a [u8],
    /// Every pair of brackets, in the order they open.
    pairs: Vec<Pair<'a>>,
    /// Where each pair that is always open begins and ends, in order.
    always_open: Vec<(usize, usize)>,
    /// Where each line break of the text is.
    line_breaks: Vec<usize>,
    edits: Vec<TextEdit>,
    /// Where each line the layout decides on begins, and its depth.
    lines: Vec<(usize, usize)>,
}

/// Whether `nodes`, which stand between brackets, are statements: they are
/// parted by semicolons and not by commas.
fn are_statements(nodes: &[Node]) -> bool {
    nodes
        .iter()
        .any(|n| matches!(n.kind(), ";" | "variable_definition_sequence"))
}

/// What `brackets` hold, parted at the commas: the first node and the last
/// of each item, its comma being the last where it has one.
fn items_of<'a>(brackets: &Brackets<'a>) -> Vec<(Node<'a>, Node<'a>)> {
    let mut nodes = Vec::new();
    for node in brackets.contents() {
        if node.kind() == "parameter_call_list" {
            let mut cursor = node.walk();
            nodes.extend(node.children(&mut cursor));
        } else {
            nodes.push(node);
        }
    }
    let mut items: Vec<(Node, Node)> = Vec::new();
    let mut open = false;
    for node in nodes.into_iter().filter(|n| !is_comment(*n)) {
        match items.last_mut() {
            Some(item) if open => item.1 = node,
            _ => items.push((node, node)),
        }
        open = node.kind() != ",";
    }
    items
}

/// Whether what `brackets` hold stays on lines of its own however narrow
/// it is: a comment stands in it, or a comma follows its last item.
fn stays_open(brackets: &Brackets) -> bool {
    let contents = brackets.contents();
    let holds_comment = |n: &Node| {
        let mut cursor = n.walk();
        is_comment(*n)
            || (n.kind() == "parameter_call_list" && n.children(&mut cursor).any(is_comment))
    };
    let last = contents.iter().rfind(|n| !is_comment(**n));
    contents.iter().any(holds_comment) || last.is_some_and(|n| n.kind() == ",")
}

/// The node an argument is, under what wraps it.
fn unwrapped(mut node: Node) -> Node {
    while matches!(
        node.kind(),
        "argument_calls" | "unnamed_argument" | "literal"
    ) && node.child_count() == 1
        && let Some(child) = node.child(0)
    {
        node = child;
    }
    node
}

/// The block an argument of a call is, when it is one: named or not.
fn block_of(argument: Node) -> Option<Node> {
    let inner = argument.child(0)?;
    inner
        .child(inner.child_count().checked_sub(1)?)
        .filter(|n| n.kind() == "function_block")
}

/// What a statement assigns or returns, or the statement itself.
fn value_of(node: Node) -> Node {
    let last = node.child(node.child_count().saturating_sub(1));
    match node.kind() {
        "variable_definition" | "function_definition" | "return_statement" | "var_binding" => {
            last.map_or(node, value_of)
        }
        "variable_definition_sequence" => {
            let mut cursor = node.walk();
            node.children(&mut cursor)
                .find(|n| n.kind() == "var_binding")
                .map_or(node, value_of)
        }
        "binary_expression" if !is_chain(node) => last.map_or(node, value_of),
        _ => node,
    }
}

impl<'a> Layout<'a> {
    fn new(cx: &'a Ctx) -> Self {
        let mut layout = Self {
            cx,
            bytes: cx.bytes(),
            pairs: Vec::new(),
            always_open: Vec::new(),
            line_breaks: (0..cx.bytes().len())
                .filter(|&i| cx.bytes()[i] == b'\n')
                .collect(),
            edits: Vec::new(),
            lines: Vec::new(),
        };
        layout.collect(cx.tree.root_node());
        layout
            .pairs
            .sort_by_key(|pair| pair.brackets.open.start_byte());
        layout.always_open.sort_unstable();
        for i in (0..layout.pairs.len()).rev() {
            let end = layout.pairs[i].brackets.close.end_byte();
            let mut after = i + 1;
            while layout
                .pairs
                .get(after)
                .is_some_and(|pair| pair.brackets.open.start_byte() < end)
            {
                after = layout.pairs[after].after;
            }
            layout.pairs[i].after = after;
        }
        layout
    }

    /// Finds the pairs of brackets under `node`, and what is always open.
    fn collect(&mut self, node: Node<'a>) {
        let mut cursor = node.walk();
        let mut comment = false;
        for child in node.children(&mut cursor) {
            comment |= is_comment(child);
            self.collect(child);
        }
        // What holds a comment is open: a chain and a list of
        // declarations here, and what stands between brackets below.
        if comment && (is_chain(node) || node.kind() == "variable_definition_sequence") {
            self.always_open.push((node.start_byte(), node.end_byte()));
        }
        if let Some(brackets) = brackets_of(node) {
            let contents: Vec<Node> = brackets
                .contents()
                .into_iter()
                .filter(|n| !is_comment(*n))
                .collect();
            let statements = if are_statements(&contents) || node.kind() == "function_block" {
                contents.iter().filter(|n| n.kind() != ";").count()
            } else {
                0
            };
            let always_open = match node.kind() {
                "function_block" => statements > 1,
                "class_def" => true,
                "code_block" => is_region(node) || statements > 1,
                _ => false,
            } || stays_open(&brackets);
            if always_open {
                self.always_open
                    .push((brackets.open.start_byte(), brackets.close.end_byte()));
            }
            self.pairs.push(Pair {
                owner: node,
                brackets,
                after: 0,
            });
        }
    }

    /// Whether `from..to` cannot stand on one line whatever its width: a
    /// line break is in it, or something that is always open.
    fn must_break(&self, from: usize, to: usize) -> bool {
        // One that begins in it and ends past it is being opened, and
        // `from..to` is the line it begins on.
        let i = self.always_open.partition_point(|&(open, _)| open < from);
        self.always_open[i..]
            .iter()
            .take_while(|&&(open, _)| open < to)
            .any(|&(_, close)| close <= to)
            || self.line_breaks_in(from, to).next().is_some()
    }

    /// The line breaks in `from..to`.
    fn line_breaks_in(&self, from: usize, to: usize) -> impl Iterator<Item = usize> + '_ {
        let first = self.line_breaks.partition_point(|&at| at < from);
        self.line_breaks[first..]
            .iter()
            .copied()
            .take_while(move |&at| at < to)
    }

    /// The columns `from..to` takes on a line. A tab between two tokens is
    /// counted as the one blank it stands for: counted wider, it would
    /// break a line that fits once it is opened and the tab is gone.
    fn columns(&self, from: usize, to: usize) -> usize {
        let is_char = |b: &&u8| **b & 0xC0 != 0x80;
        self.bytes[from..to].iter().filter(is_char).count()
    }

    /// Whether `from..to` can stand on one line at `depth`.
    fn fits(&self, from: usize, to: usize, depth: usize) -> bool {
        !self.must_break(from, to)
            && depth * self.cx.indent_style.width() + self.columns(from, to) <= self.cx.line_width
    }

    /// A line break before `node`, which begins a line at `depth`.
    fn break_before(&mut self, node: Node<'a>, depth: usize) {
        let (blanks, at) = (blanks_before(self.bytes, node), node.start_byte());
        // What is left as written keeps its lines.
        if self.cx.is_kept(blanks, at) {
            return;
        }
        self.lines.push((at, depth));
        if self.bytes[end_of_token_before(node)..at].contains(&b'\n') {
            return;
        }
        self.edits.push(TextEdit {
            start_byte: blanks,
            end_byte: at,
            replacement: "\n".to_string(),
        });
    }

    /// A line break after `node`, where the line after it begins at
    /// `depth`. A comment that ends the line of `node` stays there; one
    /// that stands before what follows goes with it.
    fn break_after(&mut self, node: Node<'a>, depth: usize) {
        let Some(first) = next_token(node) else {
            return;
        };
        let mut token = first;
        loop {
            let at = token.start_byte();
            if self.bytes[end_of_token_before(token)..at].contains(&b'\n') {
                // (A closing bracket there begins its own line, at the
                // depth of the line its pair was opened on.)
                if !self.cx.keeps(at) && !matches!(token.kind(), "}" | ")" | "]") {
                    self.lines.push((at, depth));
                }
                return;
            }
            match next_token(token).filter(|_| is_comment(token)) {
                Some(next) => token = next,
                None => break,
            }
        }
        self.break_before(first, depth);
    }

    fn file(&mut self) {
        let root = self.cx.tree.root_node();
        let mut cursor = root.walk();
        let statements: Vec<Node> = root.children(&mut cursor).collect();
        self.statements(&statements, 0);
    }

    /// The statements among `nodes`, each on a line of its own.
    fn statements(&mut self, nodes: &[Node<'a>], depth: usize) {
        let mut above: Option<Node> = None;
        let mut nodes = nodes.iter().copied().peekable();
        while let Some(node) = nodes.next() {
            if is_comment(node) {
                continue;
            }
            if node.kind() == ";" {
                above = above.map(|_| node);
                continue;
            }
            let last = nodes.next_if(|n| n.kind() == ";").unwrap_or(node);
            if let Some(above) = above {
                self.break_after(above, depth);
            }
            self.statement(node, last.end_byte(), depth);
            above = Some(last);
        }
    }

    /// Lays out the statement `node`, which begins a line at `depth` and
    /// ends at `end`, its semicolon included.
    fn statement(&mut self, node: Node<'a>, end: usize, depth: usize) {
        match node.kind() {
            "class_def" => return self.class(node, depth),
            "code_block" if is_region(node) => return self.region(node, depth),
            _ => {}
        }
        let start = node.start_byte();
        if self.cx.keeps(start) || self.fits(start, end, depth) {
            return;
        }
        if node.kind() == "variable_definition_sequence" {
            let mut cursor = node.walk();
            let commas: Vec<Node> = node
                .children(&mut cursor)
                .filter(|n| n.kind() == ",")
                .collect();
            if !commas.is_empty() {
                return self.declarations(start, end, &commas, depth);
            }
        }
        let value = value_of(node);
        if self.chain(value, start, end, depth, depth + 1, false)
            || self.messages(value, start, end, depth, depth + 1)
        {
            return;
        }
        self.line(start, end, depth);
    }

    /// The body of a class: its members, each on a line of its own.
    fn class(&mut self, node: Node<'a>, depth: usize) {
        let Some(brackets) = brackets_of(node) else {
            return;
        };
        let contents = brackets.contents();
        if contents.is_empty() {
            return;
        }
        self.break_after(brackets.head, depth + 1);
        let mut above: Option<Node> = None;
        let mut member: Vec<Node> = Vec::new();
        for node in contents.into_iter().filter(|n| !is_comment(*n)) {
            member.push(node);
            // A declaration ends with its semicolon, a method with its body.
            if !matches!(node.kind(), ";" | "function_block") {
                continue;
            }
            if let Some(above) = above {
                self.break_after(above, depth + 1);
            }
            let (from, to) = (member[0].start_byte(), node.end_byte());
            let commas: Vec<Node> = member.iter().copied().filter(|n| n.kind() == ",").collect();
            if self.cx.keeps(from) {
                // Left as written.
            } else if node.kind() == ";" && !commas.is_empty() && !self.fits(from, to, depth + 1) {
                self.declarations(from, to, &commas, depth + 1);
            } else {
                self.line(from, to, depth + 1);
            }
            above = Some(node);
            member.clear();
        }
        self.break_before(brackets.close, depth);
    }

    /// A region of a file: its statements, as deep as its parentheses.
    fn region(&mut self, node: Node<'a>, depth: usize) {
        let Some(brackets) = brackets_of(node) else {
            return;
        };
        let contents = brackets.contents();
        if contents.is_empty() || contents.iter().any(|n| n.kind() == ",") {
            return;
        }
        self.break_after(brackets.head, depth);
        self.statements(&contents, depth);
        self.break_before(brackets.close, depth);
    }

    /// The declarations of `from..to`, parted by `commas`, a line each.
    fn declarations(&mut self, from: usize, to: usize, commas: &[Node<'a>], depth: usize) {
        let (mut from, mut at) = (from, depth);
        for comma in commas {
            self.line(from, comma.end_byte(), at);
            self.break_after(*comma, depth + 1);
            let next = std::iter::successors(comma.next_sibling(), Node::next_sibling)
                .find(|n| !is_comment(*n));
            (from, at) = (next.map_or(to, |n| n.start_byte()), depth + 1);
        }
        self.line(from, to, at);
    }

    /// Breaks `chain`, which is the value of the statement `from..to` or
    /// all that stands between a pair of brackets, before its operators,
    /// when it has any.
    /// The lines after the first stand at `runs_on`. Whether it did: a
    /// chain of one operator in a statement is left whole when opening a
    /// pair of brackets serves.
    fn chain(
        &mut self,
        chain: Node<'a>,
        from: usize,
        to: usize,
        depth: usize,
        runs_on: usize,
        between_brackets: bool,
    ) -> bool {
        let all = operators_of(chain);
        if all.is_empty() {
            return false;
        }
        // Keyword messages bind loosest: the chain breaks at them first.
        let keywords: Vec<Node> = all
            .iter()
            .copied()
            .filter(|op| op.kind() == "method_name")
            .collect();
        let breaks = if keywords.is_empty() {
            all.clone()
        } else {
            keywords
        };
        // A chain with a comment in it, or a line break that stays, is
        // broken whatever it is.
        let pairs = self.pairs_in(from, to);
        let holds_comment = all.iter().filter_map(Node::parent).any(|link| {
            let mut cursor = link.walk();
            link.children(&mut cursor).any(is_comment)
        });
        if !between_brackets
            && breaks.len() == 1
            && !holds_comment
            && self.cuts(from, to, &pairs).is_empty()
            && self.brackets_serve(chain, breaks[0], from, to, depth, &pairs)
        {
            return false;
        }
        let (mut from, mut at) = (from, depth);
        for op in breaks {
            self.links(
                from,
                self.code_end(from, op.start_byte()),
                at,
                runs_on,
                &all,
            );
            self.break_before(op, runs_on);
            (from, at) = (op.start_byte(), runs_on);
        }
        self.links(from, to, at, runs_on, &all);
        true
    }

    /// Breaks `chain`, a chain of messages that is the value of the
    /// statement `from..to` or an item between brackets, before each of
    /// its dots, when that serves: it has two dots or more to break at, a
    /// line of it is too wide, and what stands before the first dot fits on
    /// its line (were that to be opened itself, the messages would hang
    /// under its closing bracket). A chain broken already is broken before
    /// each dot whatever else is so. The lines after the first stand at
    /// `runs_on`. Whether it did.
    fn messages(
        &mut self,
        chain: Node<'a>,
        from: usize,
        to: usize,
        depth: usize,
        runs_on: usize,
    ) -> bool {
        let dots = dots_of(chain, self.bytes);
        // A line break that stays before one of its dots (a comment ends
        // the line above) leaves no choice: the chain is broken already,
        // and is broken before every dot.
        let is_broken = dots.iter().any(|dot| begins_line(*dot, self.bytes));
        let serves = || {
            dots.len() >= 2
                && self.is_too_wide(from, to, depth)
                && self.fits(from, self.code_end(from, dots[0].start_byte()), depth)
        };
        if !is_broken && !serves() {
            return false;
        }
        let (mut from, mut at) = (from, depth);
        for dot in dots {
            self.line(from, self.code_end(from, dot.start_byte()), at);
            self.break_before(dot, runs_on);
            (from, at) = (dot.start_byte(), runs_on);
        }
        self.line(from, to, at);
        true
    }

    /// Whether a line of `from..to` is too wide at `depth`, as it stands:
    /// what a pair of brackets holds that must be open anyway is on lines
    /// of its own and is not counted. Such text is long, and not wide.
    fn is_too_wide(&self, from: usize, to: usize, depth: usize) -> bool {
        let wide = |from: usize, to: usize| {
            depth * self.cx.indent_style.width() + self.columns(from, to) > self.cx.line_width
        };
        let mut start = from;
        for i in self.pairs_in(from, to) {
            let brackets = self.pairs[i].brackets;
            if self.must_break(brackets.open.end_byte(), brackets.close.start_byte()) {
                if wide(start, brackets.open.end_byte()) {
                    return true;
                }
                start = brackets.close.start_byte();
            }
        }
        wide(start, to)
    }

    /// A stretch of a chain between two of the operators it broke at: when
    /// it is too wide, it breaks before the operators it holds.
    fn links(&mut self, from: usize, to: usize, depth: usize, runs_on: usize, all: &[Node<'a>]) {
        let within = all
            .iter()
            .filter(|op| from < op.start_byte() && op.start_byte() < to);
        let (mut from, mut at) = (from, depth);
        if !self.fits(from, to, depth) {
            for op in within {
                self.line(from, self.code_end(from, op.start_byte()), at);
                self.break_before(*op, runs_on);
                (from, at) = (op.start_byte(), runs_on);
            }
        }
        self.line(from, to, at);
    }

    /// Whether opening a pair of brackets is enough for the statement
    /// `from..to`, whose value is `chain`, a chain of the one operator
    /// `operator`: the pair ends the chain; or the chain begins with it and
    /// what follows it fits on its line; or it stands before the operator
    /// in an operand too wide for a line by itself, which is opened
    /// whatever is done, and what follows it fits on its line.
    fn brackets_serve(
        &self,
        chain: Node,
        operator: Node,
        from: usize,
        to: usize,
        depth: usize,
        pairs: &[usize],
    ) -> bool {
        self.choose(from, to, depth, pairs).is_some_and(|choice| {
            let brackets = self.pairs[choice.of].brackets;
            let rest_fits = || self.fits(brackets.close.start_byte(), to, depth);
            let ends = brackets.close.end_byte() == chain.end_byte();
            let begins = brackets.open.start_byte() == chain.start_byte() && rest_fits();
            let opened_anyway = brackets.close.end_byte() <= operator.start_byte()
                && !self.fits(from, self.code_end(from, operator.start_byte()), depth)
                && rest_fits();
            choice.head_fits && (ends || begins || opened_anyway)
        })
    }

    /// The outermost pairs of brackets that stand whole in `from..to`.
    fn pairs_in(&self, from: usize, to: usize) -> Vec<usize> {
        let mut found = Vec::new();
        let mut i = self
            .pairs
            .partition_point(|pair| pair.brackets.open.start_byte() < from);
        while let Some(pair) = self.pairs.get(i)
            && pair.brackets.close.end_byte() <= to
        {
            found.push(i);
            i = pair.after;
        }
        found
    }

    /// The line breaks in `from..to` that no pair of `pairs` holds: where
    /// the line is broken already, and nothing the layout does can join it.
    fn cuts(&self, from: usize, to: usize, pairs: &[usize]) -> Vec<usize> {
        let mut cuts = Vec::new();
        let mut start = from;
        let ends = pairs.iter().map(|&i| {
            let brackets = self.pairs[i].brackets;
            (brackets.open.start_byte(), brackets.close.end_byte())
        });
        for (end, next) in ends.chain([(to, to)]) {
            cuts.extend(self.line_breaks_in(start, end));
            start = next;
        }
        cuts
    }

    /// Where the code of `start..end` ends: before the comments that end
    /// it, and the blanks.
    fn code_end(&self, start: usize, mut end: usize) -> usize {
        let root = self.cx.tree.root_node();
        while end > start {
            if self.bytes[end - 1].is_ascii_whitespace() {
                end -= 1;
                continue;
            }
            let last = root.descendant_for_byte_range(end - 1, end);
            match last.filter(|n| is_comment(*n) && n.start_byte() >= start) {
                Some(comment) => end = comment.start_byte(),
                None => break,
            }
        }
        end
    }

    /// Lays out `from..to`, which stands on a line at `depth` and is no
    /// statement, list or chain to be parted as one: a pair of brackets on
    /// it is opened when it does not fit.
    fn line(&mut self, from: usize, to: usize, depth: usize) {
        if self.fits(from, to, depth) {
            return;
        }
        let pairs = self.pairs_in(from, to);
        // The tests and blocks of a `case`, or of a `switch` written with
        // blocks, that stands whole on the line get lines before anything
        // on it is opened.
        let cases = pairs.iter().find_map(|&i| {
            let first = self.pairs[i].owner;
            let cases = first.parent().filter(|n| from <= n.start_byte())?;
            cases_of(cases).filter(|blocks| {
                blocks[0].id() == first.id() && blocks[blocks.len() - 1].end_byte() <= to
            })
        });
        if let Some(blocks) = cases {
            return self.cases(&blocks, from, to, depth);
        }
        let cuts = self.cuts(from, to, &pairs);
        if !cuts.is_empty() {
            // Each line it is on already is laid out by itself.
            let mut start = from;
            for cut in cuts.into_iter().chain([to]) {
                let end = self.code_end(start, cut);
                if start < end {
                    self.line(start, end, depth);
                }
                start = cut
                    + self.bytes[cut..to]
                        .iter()
                        .take_while(|b| b.is_ascii_whitespace())
                        .count();
            }
            return;
        }
        if let Some(choice) = self.choose(from, to, depth, &pairs) {
            self.open(choice.opens, from, to, depth);
        }
    }

    /// Whether the pair `i` can be opened to any use on a line of
    /// `columns`: it holds something, and it must be opened anyway, or each
    /// thing it holds would be narrower one level in than the line is, or
    /// what it holds can be broken in its turn to the same end.
    fn is_worth_opening(&self, i: usize, columns: usize) -> bool {
        let Pair {
            owner, brackets, ..
        } = self.pairs[i];
        let contents = brackets.contents();
        let (Some(first), Some(last)) = (contents.first(), contents.last()) else {
            return false;
        };
        if self.must_break(brackets.open.start_byte(), brackets.close.end_byte()) {
            return true;
        }
        let (from, to) = (first.start_byte(), last.end_byte());
        let items = items_of(&brackets);
        let widest = if owner.kind() == "function_block" {
            self.columns(from, to)
        } else {
            items
                .iter()
                .map(|(first, last)| self.columns(first.start_byte(), last.end_byte()))
                .max()
                .unwrap_or(0)
        };
        // One level in, on a line of `widest` columns.
        let inside = self.cx.indent_style.width() + widest;
        let is_chain = items.len() == 1 && !operators_of(unwrapped(items[0].0)).is_empty();
        inside < columns
            || is_chain
            || self
                .pairs_in(from, to)
                .into_iter()
                .any(|inner| self.is_worth_opening(inner, widest))
    }

    /// The block that hugs the call whose parentheses are the pair `i`:
    /// its last argument, when no other argument is a block and nothing
    /// follows it between the parentheses.
    fn hugged(&self, i: usize) -> Option<usize> {
        let Pair {
            owner, brackets, ..
        } = self.pairs[i];
        let is_call = matches!(
            owner.kind(),
            "function_call" | "method_call" | "apply_call" | "instance_variable_setter_call"
        );
        let mut contents = brackets.contents().into_iter().filter(|n| !is_comment(*n));
        let arguments = contents.next().filter(|n| {
            is_call && n.kind() == "parameter_call_list" && contents.next().is_none()
        })?;
        let mut cursor = arguments.walk();
        let arguments: Vec<Node> = arguments
            .children(&mut cursor)
            .filter(|n| n.kind() == "argument_calls")
            .collect();
        let (last, others) = arguments.split_last()?;
        let block = block_of(*last)?;
        if others.iter().any(|n| block_of(*n).is_some())
            || next_token(block)?.id() != brackets.close.id()
        {
            return None;
        }
        self.pair_of(block)
    }

    /// Which of the pairs the brackets of `node` are.
    fn pair_of(&self, node: Node) -> Option<usize> {
        let open = brackets_of(node)?.open.start_byte();
        self.pairs
            .binary_search_by_key(&open, |pair| pair.brackets.open.start_byte())
            .ok()
    }

    /// The pair to open on the line `from..to`, of `pairs`, which stand
    /// on it: the last that leaves the line it begins on within its width,
    /// as long as what follows the pair fits on a line too; a block that
    /// ends the line whether it does or not; and the last when none does.
    fn choose(&self, from: usize, to: usize, depth: usize, pairs: &[usize]) -> Option<Choice> {
        let columns = self.columns(from, to);
        let candidates: Vec<usize> = pairs
            .iter()
            .copied()
            .filter(|&i| self.is_worth_opening(i, columns))
            .collect();
        let last = *candidates.last()?;
        // A block that ends the line is opened first where the line is too
        // wide. Where the line only holds something that is always open,
        // that is what is opened, and the block when it is that.
        let last_brackets = self.pairs[last].brackets;
        let opens_last = !self.must_break(from, to)
            || self.must_break(
                last_brackets.open.start_byte(),
                last_brackets.close.end_byte(),
            );
        for &i in candidates.iter().rev() {
            let Pair {
                owner, brackets, ..
            } = self.pairs[i];
            if i != last && !self.fits(brackets.close.start_byte(), to, depth) {
                break;
            }
            let hugged = self.hugged(i).filter(|&block| {
                let head = self.pairs[block].brackets.head;
                self.is_worth_opening(block, columns) && self.fits(from, head.end_byte(), depth)
            });
            if let Some(block) = hugged {
                return Some(Choice {
                    opens: block,
                    of: i,
                    head_fits: true,
                });
            }
            // The first block of an `if` is opened with the second, and
            // the line ends where it begins.
            let head = self
                .other_block_of_if(owner, owner.prev_sibling())
                .map(|then| self.pairs[then].brackets)
                .filter(|then| then.open.start_byte() >= from)
                .map_or(brackets.head, |then| then.head);
            let head_fits = self.fits(from, head.end_byte(), depth);
            if head_fits || (i == last && opens_last && owner.kind() == "function_block") {
                return Some(Choice {
                    opens: i,
                    of: i,
                    head_fits,
                });
            }
        }
        Some(Choice {
            opens: last,
            of: last,
            head_fits: false,
        })
    }

    /// Opens the pair `i` on the line `from..to`: what stands before its
    /// contents stays on the line, the contents go one level in, and the
    /// closing bracket begins the line of what follows it.
    fn open(&mut self, i: usize, from: usize, to: usize, depth: usize) {
        let Pair {
            owner, brackets, ..
        } = self.pairs[i];
        let contents = brackets.contents();
        // A switch keeps the value it switches on on its first line.
        let value = contents
            .iter()
            .find(|n| n.kind() == ",")
            .filter(|_| owner.kind() == "switch");
        let head = value.map_or(brackets.head, |comma| *comma);
        self.head(i, from, head.end_byte(), depth);
        if owner.kind() == "function_block" || are_statements(&contents) {
            self.break_after(head, depth + 1);
            self.statements(&contents, depth + 1);
        } else {
            self.items(&brackets, head, value.is_some(), depth + 1);
        }
        self.break_before(brackets.close, depth);
        // The two blocks of an `if` are opened together.
        match self.other_block_of_if(owner, owner.next_sibling()) {
            Some(other) if self.pairs[other].brackets.close.end_byte() <= to => {
                self.open(other, brackets.close.start_byte(), to, depth);
            }
            _ => self.line(brackets.close.start_byte(), to, depth),
        }
    }

    /// The pair of `other`, when it is the other block of the `if` that
    /// `block` is one block of, and holds something.
    fn other_block_of_if(&self, block: Node, other: Option<Node>) -> Option<usize> {
        let is_block = |n: &Node| n.kind() == "function_block";
        let other = other.filter(|n| {
            is_block(n) && is_block(&block) && block.parent().is_some_and(|n| n.kind() == "if")
        })?;
        self.pair_of(other)
            .filter(|&i| self.is_worth_opening(i, usize::MAX))
    }

    /// Lays out `from..to`, the line the pair `i` is opened on, up to
    /// where its contents begin.
    fn head(&mut self, i: usize, from: usize, to: usize, depth: usize) {
        let Pair {
            owner, brackets, ..
        } = self.pairs[i];
        // The two blocks of an `if` are opened together.
        let then_block = self
            .other_block_of_if(owner, owner.prev_sibling())
            .filter(|&then| self.pairs[then].brackets.open.start_byte() >= from);
        if let Some(then) = then_block {
            return self.open(then, from, to, depth);
        }
        // A comment among a block's parameters leaves them on lines of
        // their own, which stand as deep as the block's body.
        let open = brackets.open.end_byte();
        match self.bytes[open..to].iter().position(|&b| b == b'\n') {
            Some(at) if open > from => {
                self.line(from, self.code_end(from, open + at), depth);
                let rest = open
                    + at
                    + self.bytes[open + at..to]
                        .iter()
                        .take_while(|b| b.is_ascii_whitespace())
                        .count();
                self.line(rest, to, depth + 1);
            }
            _ => self.line(from, to, depth),
        }
    }

    /// What `brackets` hold, on lines at `depth` that begin after `head`:
    /// on one line when it fits there; otherwise an item to a line, and an
    /// item that is a chain and too wide for its line, a line to each
    /// operator. The items of a `switch`, whose value stays on its first
    /// line, always get lines.
    fn items(&mut self, brackets: &Brackets<'a>, head: Node<'a>, is_switch: bool, depth: usize) {
        self.break_after(head, depth);
        let mut items = items_of(brackets);
        if is_switch {
            items.remove(0);
        }
        let (Some(first), Some(last)) = (items.first(), items.last()) else {
            return;
        };
        let (from, to) = (first.0.start_byte(), last.1.end_byte());
        let stays_open = stays_open(brackets);
        if !is_switch && !stays_open && self.fits(from, to, depth) {
            return;
        }
        // A key and its value share a line, and a test and its block.
        // (A list of nothing but symbols is no keys and values.)
        let is_key = |item: &(Node, Node)| unwrapped(item.0).kind() == "symbol";
        let in_pairs = is_switch
            || (items.len() >= 4
                && items.len().is_multiple_of(2)
                && items.iter().step_by(2).all(is_key)
                && !items.iter().all(is_key));
        let mut above: Option<Node> = None;
        for group in items.chunks(if in_pairs { 2 } else { 1 }) {
            let (first, last) = (group[0].0, group[group.len() - 1].1);
            if let Some(above) = above {
                self.break_after(above, depth);
            }
            // An item too wide for its line that is a chain breaks before
            // its operators, level with it: its brackets come after.
            let (from, to) = (first.start_byte(), last.end_byte());
            let is_one = group.len() == 1 && (first.id() == last.id() || last.kind() == ",");
            if !is_one
                || self.fits(from, to, depth)
                || !(self.chain(unwrapped(first), from, to, depth, depth, true)
                    || self.messages(unwrapped(first), from, to, depth, depth))
            {
                self.line(from, to, depth);
            }
            above = Some(last);
        }
    }

    /// The tests and blocks of a `case`, or of a `switch` written with
    /// blocks, which the line `from..to` holds: a test and its block to a
    /// line, one level in, and what stands before the first on the line
    /// above them.
    fn cases(&mut self, blocks: &[Node<'a>], from: usize, to: usize, depth: usize) {
        let head = self.code_end(from, end_of_token_before(blocks[0]));
        self.line(from, head, depth);
        let mut pairs = blocks.chunks(2).peekable();
        while let Some(pair) = pairs.next() {
            self.break_before(pair[0], depth + 1);
            let end = pairs.peek().map_or(to, |next| end_of_token_before(next[0]));
            self.line(pair[0].start_byte(), self.code_end(from, end), depth + 1);
        }
    }
}

#[cfg(test)]
mod tests {
    use crate::engine::layout::DEFAULT_LINE_WIDTH;
    use crate::format_source;

    /// `src` formatted by every rule, so that the lines this rule makes are
    /// seen with the indent they get, after checking that a second pass
    /// changes nothing.
    fn format(src: &str) -> String {
        let once = format_source(src).unwrap();
        assert_eq!(format_source(&once).unwrap(), once, "a second pass");
        once
    }

    /// `src` is laid out as it should be: it formats to itself, and so
    /// does it with every line break in it taken away.
    fn assert_layout(src: &str) {
        assert_eq!(format(src), src);
        let joined: Vec<&str> = src.lines().map(str::trim_start).collect();
        assert_eq!(format(&joined.join(" ")), src, "joined");
    }

    /// `src` formats to itself.
    fn assert_stays(src: &str) {
        assert_eq!(format(src), src);
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
    fn test_a_statement_that_fits_stands_on_one_line_however_it_was_typed() {
        for (src, want) in [
            ("x = foo(a,\n    b\n);\n", "x = foo(a, b);\n"),
            ("foo(a\n\n    )\n", "foo(a)\n"),
            ("foo($ \n)\n", "foo($ )\n"),
            ("foo(bar(a\n)\n)\n", "foo(bar(a))\n"),
            ("x = [\n    1,\n    2,\n    3\n];\n", "x = [1, 2, 3];\n"),
            (
                "x = [\n    $,, 2, $(, \"a, (b\", $],\n    f(1, 2), [3, 4]\n];\n",
                "x = [$,, 2, $(, \"a, (b\", $], f(1, 2), [3, 4]];\n",
            ),
            (
                "x = (\n    a: $,, b: 2,\n    c: \"x, y\", d: 4\n);\n",
                "x = (a: $,, b: 2, c: \"x, y\", d: 4);\n",
            ),
            ("x = (a + b\n);\n", "x = (a + b);\n"),
            ("x = [1, 2,   $ \n];\n", "x = [1, 2, $ ];\n"),
            ("x = [$\t,\n    $ ,\n    3\n];\n", "x = [$\t, $ , 3];\n"),
            (
                "x = [\n    -1,\n    3.14,\n    \"foo\",\n    \\a,\n    b.c,\n    (1 + 2),\n    [3, 4]\n];\n",
                "x = [-1, 3.14, \"foo\", \\a, b.c, (1 + 2), [3, 4]];\n",
            ),
            ("a.\n\n    b;\n", "a.b;\n"),
            ("x = \"a.\n    b\";\n", "x = \"a.\n    b\";\n"),
            ("f =\n{\n    1\n};\n", "f = { 1 };\n"),
            ("f = {\n    |a|\n    a\n};\n", "f = { |a| a };\n"),
            ("x = if (a)\n{ 1 }\n{ 2 };\n", "x = if (a) { 1 } { 2 };\n"),
            ("a.\n    b.  \n    c(1);\n", "a.b.c(1);\n"),
            ("a\n    .b\n    .c;\n", "a.b.c;\n"),
            ("a.\r\n    b;\n", "a.b;\n"),
            ("x = $\";\na.\n    b;\n", "x = $\";\na.b;\n"),
            ("x = a +\n    b;\n", "x = a + b;\n"),
            (
                "SynthDef(\\x, { |out|\n    Out.ar(out, SinOsc.ar)\n}).add;\n",
                "SynthDef(\\x, { |out| Out.ar(out, SinOsc.ar) }).add;\n",
            ),
        ] {
            assert_eq!(format(src), want);
        }
    }

    #[test]
    fn test_a_joined_line_is_measured_with_the_indent_it_will_have() {
        // 59 columns once joined. The line stands at no depth, so the 30
        // blanks before it will go, and are not counted.
        let numbers = ["1000"; 9].join(",\n");
        let joined = format(&format!("{}x = [\n{numbers}\n];\n", " ".repeat(30)));
        assert_eq!(joined, format!("x = [{}];\n", ["1000"; 9].join(", ")));
        // 77 columns once joined, and one level deep: 81 with the indent it
        // will have, though the line has none now.
        let numbers = ["1000"; 12].join(",\n");
        assert_eq!(
            format(&format!("f = {{\nx = [\n{numbers}\n];\ny\n}};\n")),
            format!(
                "f = {{\n    x = [\n        {}\n    ];\n    y\n}};\n",
                ["1000"; 12].join(", ")
            )
        );
    }

    #[test]
    fn test_each_statement_has_a_line_and_the_blank_lines_between_them_stay() {
        assert_eq!(
            format("a = 1; b = 2;\n\n\nc = 3; d = 4;\n"),
            "a = 1;\nb = 2;\n\n\nc = 3;\nd = 4;\n"
        );
        assert_eq!(
            format("f = { a.value;\n\n    b.value };\n"),
            "f = {\n    a.value;\n\n    b.value\n};\n"
        );
    }

    #[test]
    fn test_a_region_of_a_file_is_always_open_and_not_indented() {
        assert_eq!(format("(a = 1; b = 2)\n"), "(\na = 1;\nb = 2\n)\n");
        assert_eq!(format("( a.postln )\n"), "(\na.postln\n)\n");
        assert_stays("(\n\na = 1;\n\n)\n");
        // One that is used is no region.
        assert_layout("(a + b).postln;\n");
    }

    #[test]
    fn test_a_block_of_two_statements_is_always_open_and_one_of_one_only_when_too_wide() {
        assert_eq!(
            format("if (told[member] != place) { told[member] = place; tell.(member) }\n"),
            "if (told[member] != place) {\n    told[member] = place;\n    tell.(member)\n}\n"
        );
        assert_eq!(format("f = { |x|\n    x + 1\n};\n"), "f = { |x| x + 1 };\n");
        assert_eq!(
            format("f = { var a = 1; a };\n"),
            "f = {\n    var a = 1;\n    a\n};\n"
        );
        assert_eq!(
            format(
                "list.do { |item| var doubled = item * 2; doubled.postln; results.add(doubled + offsetForTheResults) };\n"
            ),
            "list.do { |item|\n    var doubled = item * 2;\n    doubled.postln;\n    results.add(doubled + offsetForTheResults)\n};\n"
        );
        // A function that is assigned, and the body of a method.
        let long = "a".repeat(76);
        assert_eq!(
            format(&format!("f = {{ |a, b| {long} }};\n")),
            format!("f = {{ |a, b|\n    {long}\n}};\n")
        );
        assert_eq!(
            format(&format!(
                "Foo {{ bar {{ |a, b| ^{long} }} baz {{ ^1 }} }}\n"
            )),
            format!("Foo {{\n    bar {{ |a, b|\n        ^{long}\n    }}\n    baz {{ ^1 }}\n}}\n")
        );
    }

    #[test]
    fn test_a_block_with_a_comment_in_it_is_open() {
        assert_eq!(
            format("f = { a /* why */ };\n"),
            "f = {\n    a /* why */\n};\n"
        );
        assert_stays("f = {\n    // nothing yet\n};\n");
        assert_stays("f = {\n    // why a\n    |a|\n    a\n};\n");
    }

    #[test]
    fn test_the_body_of_a_class_is_always_open() {
        assert_eq!(
            format(
                "Foo : Bar { var a, b = 2; classvar <c; *new { ^super.new } foo { |x| a = x; ^this } }\n"
            ),
            "Foo : Bar {\n    var a, b = 2;\n    classvar <c;\n    *new { ^super.new }\n    foo { |x|\n        a = x;\n        ^this\n    }\n}\n"
        );
        assert_stays("Foo {\n\n    var a;\n\n    foo { ^a }\n\n}\n");
    }

    #[test]
    fn test_declarations_too_wide_for_a_line_get_a_line_each() {
        assert_eq!(
            format(
                "f = {\n    var why = refusal.(msg.source, msg.part,\n        msg.values), token = msg.values[1], anotherOne;\n    why\n};\n"
            ),
            "f = {\n    var why = refusal.(msg.source, msg.part, msg.values),\n        token = msg.values[1],\n        anotherOne;\n    why\n};\n"
        );
        assert_eq!(
            format(&format!(
                "Foo {{ var <>first = 1, <second, third = {}; }}\n",
                "a".repeat(60)
            )),
            format!(
                "Foo {{\n    var <>first = 1,\n        <second,\n        third = {};\n}}\n",
                "a".repeat(60)
            )
        );
        // One that is too wide on its own line is broken there.
        assert_eq!(
            format(&format!(
                "var a = 1, b = someFunction({}, {});\n",
                "a".repeat(40),
                "b".repeat(40)
            )),
            format!(
                "var a = 1,\n    b = someFunction(\n        {},\n        {}\n    );\n",
                "a".repeat(40),
                "b".repeat(40)
            )
        );
    }

    #[test]
    fn test_a_chain_that_is_a_statement_breaks_before_each_operator() {
        assert_eq!(
            format(
                "thisIsALongerNameForX.isKindOf(Symbol) and: { x != \\none } and: { x.asString.notEmpty } and: { x.asString.every { |c| c.isPrint } };\n"
            ),
            "thisIsALongerNameForX.isKindOf(Symbol)\n    and: { x != \\none }\n    and: { x.asString.notEmpty }\n    and: { x.asString.every { |c| c.isPrint } };\n"
        );
        // What is assigned, and what is returned.
        assert_eq!(
            format(
                "x = firstOperandOfTheChain + secondOperandOfTheChain - thirdOperandOfTheChain * fourthOperandOfTheChain;\n"
            ),
            "x = firstOperandOfTheChain\n    + secondOperandOfTheChain\n    - thirdOperandOfTheChain\n    * fourthOperandOfTheChain;\n"
        );
        assert_eq!(
            format(
                "f = { ^firstOperandOfTheChain ++ secondOperandOfTheChain ++ thirdOperandOfTheChain ?? { 1 } };\n"
            ),
            "f = {\n    ^firstOperandOfTheChain\n        ++ secondOperandOfTheChain\n        ++ thirdOperandOfTheChain\n        ?? { 1 }\n};\n"
        );
        assert_eq!(
            format(
                "var x = firstOperandOfTheChain + secondOperandOfTheChain - thirdOperandOfTheChain * fourthOperand;\n"
            ),
            "var x = firstOperandOfTheChain\n    + secondOperandOfTheChain\n    - thirdOperandOfTheChain\n    * fourthOperand;\n"
        );
    }

    #[test]
    fn test_a_chain_is_all_its_operators_however_the_tree_nests_them() {
        // The tree reads `a << b.c(d)` as `(a << b).c(d)`: the operators
        // before a message are the chain's all the same.
        assert_eq!(
            format(
                "stream << \"<div class=codeMirrorContainer>\" << \"<textarea>\" << this.escapeSpecialChars(node.text) << \"</div>\";\n"
            ),
            "stream\n    << \"<div class=codeMirrorContainer>\"\n    << \"<textarea>\"\n    << this.escapeSpecialChars(node.text)\n    << \"</div>\";\n"
        );
        assert_eq!(
            format(
                "x = firstOperandOfTheChain + secondOperandOfTheChain.someMessage(withAnArgument) + third.other(1);\n"
            ),
            "x = firstOperandOfTheChain\n    + secondOperandOfTheChain.someMessage(withAnArgument)\n    + third.other(1);\n"
        );
        // One operator, and the brackets of the message that ends it serve.
        assert_eq!(
            format(
                "y = aFirstOperandOfSomeLengthHere + anotherOperand.someMessageToIt(firstArgument, secondOne);\n"
            ),
            "y = aFirstOperandOfSomeLengthHere + anotherOperand.someMessageToIt(\n    firstArgument, secondOne\n);\n"
        );
    }

    #[test]
    fn test_a_chain_breaks_at_its_keyword_messages_first() {
        // They bind loosest. The binary operators between them break only
        // where a line is still too wide.
        assert_eq!(
            format(
                "ok = firstOperandOfTheChain > secondOperandOfTheChain and: { third < fourth } or: { fifthOperandOfTheChain };\n"
            ),
            "ok = firstOperandOfTheChain > secondOperandOfTheChain\n    and: { third < fourth }\n    or: { fifthOperandOfTheChain };\n"
        );
        let (a, b) = ("a".repeat(40), "b".repeat(40));
        assert_eq!(
            format(&format!("ok = {a} > {b} and: {{ c }} or: {{ d }};\n")),
            format!("ok = {a}\n    > {b}\n    and: {{ c }}\n    or: {{ d }};\n")
        );
    }

    #[test]
    fn test_a_chain_of_one_operator_is_left_whole_when_opening_a_bracket_serves() {
        // The brackets that end it.
        assert_eq!(
            format(
                "x = aFirstOperandOfSomeLength + someFunction(firstArgumentOfAll, secondArgumentOfAll, third);\n"
            ),
            "x = aFirstOperandOfSomeLength + someFunction(\n    firstArgumentOfAll, secondArgumentOfAll, third\n);\n"
        );
        assert_eq!(
            format(
                "ok = aListOfSomeLength.includes(anItem) and: anotherListOfThem.any { |other| other > anItem };\n"
            ),
            "ok = aListOfSomeLength.includes(anItem) and: anotherListOfThem.any { |other|\n    other > anItem\n};\n"
        );
        // The brackets it begins with.
        assert_eq!(
            format(
                "x = [firstElementOfAll, secondElementOfAll, thirdElementOfAll, fourthElementOfAll] ++ rest;\n"
            ),
            "x = [\n    firstElementOfAll, secondElementOfAll, thirdElementOfAll, fourthElementOfAll\n] ++ rest;\n"
        );
        // The brackets of a first operand too wide for a line by itself:
        // they are opened whatever is done, and a line break before the
        // operator would only leave it hanging under their closing one.
        assert_layout(
            "f = {\n    snd = BPF.ar(\n        snd,\n        (0..30).normalize.linexp(0, 1, ExpRand(30, 60), ExpRand(3000, 6000)),\n        0.05\n    ).sum * 4.dbamp;\n    snd\n};\n",
        );
        // Neither: it breaks before its operator.
        assert_eq!(
            format(
                "x = someFunction(firstArgumentOfAll, secondArgumentOfAll).aMessageOfSomeLength + anotherOperand;\n"
            ),
            "x = someFunction(firstArgumentOfAll, secondArgumentOfAll).aMessageOfSomeLength\n    + anotherOperand;\n"
        );
    }

    #[test]
    fn test_a_chain_of_messages_too_wide_breaks_before_each_dot() {
        // A name that begins the chain keeps its first message.
        assert_layout(
            "f = { |duration, minFreq, maxFreq|\n    var freq;\n    freq = LFSaw.ar(ExpRand(10, 200) / duration)\n        .linlin(-1, 1, 0, 1)\n        .pow(3)\n        .linexp(0, 1, minFreq, maxFreq);\n    freq\n};\n",
        );
        // A call that begins it is followed by a line for every message.
        assert_layout(
            "x = Pbind(\\freq, Pseq([440, 550, 660], inf), \\dur, 0.25)\n    .collect { |event| event }\n    .trace\n    .play;\n",
        );
        assert_layout(
            "q = StaticText(n, n.bounds.moveTo(0, 0).insetBy(25))\n    .string_(l[i])\n    .align_(\\center);\n",
        );
        // A message too wide for its line opens its own brackets there.
        assert_layout(
            "x = Foo.bar(1)\n    .baz(\n        argumentNumberOne, argumentNumberTwo, argumentNumberThree, argumentFour\n    )\n    .qux;\n",
        );
        // Between brackets it breaks level with its first line: the
        // brackets have indented it already.
        assert_layout(
            "foo(\n    LFSaw.ar(ExpRand(10, 200) / duration)\n    .linlin(-1, 1, 0, 1)\n    .pow(3)\n    .linexp(0, 1, lowestFrequency, highestFrequency),\n    second\n);\n",
        );
    }

    #[test]
    fn test_a_chain_of_messages_with_a_line_break_that_stays_breaks_before_each_dot() {
        // A comment keeps the line break after it, whatever the width and
        // whatever begins the chain: every dot then begins a line, and what
        // a block of the chain holds stands a level in from its message.
        assert_stays(
            "x = list.sort  // sort it\n    .do { |n|\n        n.name.post;\n        n.postln\n    };\n",
        );
        assert_stays(
            "x = Foo(1)\n    // .font_(a)\n    .align_(b)\n    .handler_ { |obj|\n        obj.postln;\n        obj\n    };\n",
        );
    }

    #[test]
    fn test_a_chain_of_messages_is_left_whole_where_breaking_it_serves_nothing() {
        // It fits.
        assert_stays("x = a.b(1).c(2).d(3);\n");
        // One message after the first is no chain: the brackets open.
        let one = format(
            "x = SomeClass.method(argumentNumberOne, argumentNumberTwo, argumentNumberThree, four).finish;\n",
        );
        assert!(
            !one.lines().any(|line| line.trim_start().starts_with('.')),
            "{one}"
        );
        // No line of it is too wide: a block that is open makes it long, not
        // wide.
        assert_stays("x = a.b(1).c { |y|\n    y.postln;\n    y\n}.d;\n");
        assert_stays(
            "r = rects.collect { |rect|\n    rect.postln;\n    rect\n}.flatten.reverse;\n",
        );
        // What begins it has to be opened itself: lines of messages under
        // its closing bracket would hang from nothing.
        let hung = format(
            "x = Pbind(\\freq, Pseq([440, 550, 660, 770, 880, 990], inf), \\dur, 0.25, \\amp, 0.1, \\pan, 0).trace.play;\n",
        );
        assert!(
            !hung.lines().any(|line| line.trim_start().starts_with('.')),
            "{hung}"
        );
    }

    #[test]
    fn test_a_block_after_a_call_is_opened_whatever_stands_before_it() {
        assert_eq!(
            format(
                "MBTry.value(next[1]) { |error| me.medium.report(me.name, \\reaction, next[0], error.errorString) }\n"
            ),
            "MBTry.value(next[1]) { |error|\n    me.medium.report(me.name, \\reaction, next[0], error.errorString)\n}\n"
        );
        // What stands before it is broken when it is too wide itself.
        assert_eq!(
            format(
                "while (thisIsTheFirstCondition and: { thisIsTheSecondCondition } and: { thisIsTheThird }) { go.on };\n"
            ),
            "while (\n    thisIsTheFirstCondition\n    and: { thisIsTheSecondCondition }\n    and: { thisIsTheThird }\n) {\n    go.on\n};\n"
        );
        // A brace typed on a line of its own joins the line before.
        let long = "a".repeat(76);
        assert_eq!(
            format(&format!("if (aCondition)\n{{ {long} }};\n")),
            format!("if (aCondition) {{\n    {long}\n}};\n")
        );
        // Of two blocks after a call the last is opened, and the one
        // before it when that is not enough.
        assert_eq!(
            format(&format!("while {{ x < 10 }} {{ {} }};\n", "a".repeat(70))),
            format!("while {{ x < 10 }} {{\n    {}\n}};\n", "a".repeat(70))
        );
    }

    #[test]
    fn test_the_two_blocks_of_an_if_are_opened_together() {
        assert_eq!(
            format(
                "if (condition) { \"a long enough true branch to pass the width\" } { \"and the false one\" };\nx = 1;\n"
            ),
            "if (condition) {\n    \"a long enough true branch to pass the width\"\n} {\n    \"and the false one\"\n};\nx = 1;\n"
        );
        // The brace's line is what stands before the if, too.
        assert_eq!(
            format(
                "x = if (condition) { \"a long enough true branch to pass the width\" } { \"and the false one\" };\n"
            ),
            "x = if (condition) {\n    \"a long enough true branch to pass the width\"\n} {\n    \"and the false one\"\n};\n"
        );
        // One block of two statements opens the other.
        assert_eq!(
            format("if (a) { b; c } { d };\n"),
            "if (a) {\n    b;\n    c\n} {\n    d\n};\n"
        );
        assert_eq!(
            format("if (a) { b } { c; d };\n"),
            "if (a) {\n    b\n} {\n    c;\n    d\n};\n"
        );
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
        // Beside a call on its line, the if is what is opened.
        assert_eq!(
            format(
                "x = aCallOfSomeLength(firstArgument) + if (a.isSomething) { a.doTheFirstThing } { a.doTheSecondThing };\n"
            ),
            "x = aCallOfSomeLength(firstArgument) + if (a.isSomething) {\n    a.doTheFirstThing\n} {\n    a.doTheSecondThing\n};\n"
        );
        // An if too wide inside one that is opened is opened too.
        assert_eq!(
            format(
                "if (a) { if (b) { \"a long enough true branch for the inner if\".postln } { \"and its false one\".postln } } { 3 };\n"
            ),
            "if (a) {\n    if (b) {\n        \"a long enough true branch for the inner if\".postln\n    } {\n        \"and its false one\".postln\n    }\n} {\n    3\n};\n"
        );
    }

    #[test]
    fn test_an_if_is_measured_as_it_will_stand() {
        // One line of 81 columns.
        let (a, b) = ("a".repeat(40), "b".repeat(25));
        let src = format!("if (c) {{ {a} }} {{ {b} }}\n");
        assert_eq!(src.trim_end().len(), 81);
        assert_eq!(
            format(&src),
            format!("if (c) {{\n    {a}\n}} {{\n    {b}\n}}\n")
        );
        // 80 columns in 81 bytes: the é is two of them.
        let src = format!(
            "if (c) {{ \"{}é\" }} {{ {} }}\n",
            "a".repeat(36),
            "b".repeat(25)
        );
        assert_eq!(
            (src.trim_end().chars().count(), src.trim_end().len()),
            (80, 81)
        );
        assert_eq!(format(&src), src);
        // The blanks that end the line are not counted: they are trimmed.
        let line = format!("if (c) {{ {} }} {{ {} }};", "a".repeat(38), "b".repeat(25));
        assert_eq!(line.len(), 80);
        assert_eq!(
            format(&format!("{line}   \nx = 1;\n")),
            format!("{line}\nx = 1;\n")
        );
        // 79 columns as written, and 81 once `===` has a space each side.
        let (a, b) = ("a".repeat(34), "b".repeat(24));
        let src = format!("if (c===d) {{ {a} }} {{ {b} }};\n");
        assert_eq!(src.trim_end().len(), 79);
        assert_eq!(
            format(&src),
            format!("if (c === d) {{\n    {a}\n}} {{\n    {b}\n}};\n")
        );
    }

    #[test]
    fn test_the_width_is_the_one_asked_for() {
        let at = |width: usize, src: &str| {
            let style = crate::IndentStyle::Spaces { width: 4 };
            let once = crate::format_source_with(src, style, width).unwrap();
            let twice = crate::format_source_with(&once, style, width).unwrap();
            assert_eq!(twice, once, "a second pass at {width}");
            once
        };
        // A comment of 92 columns and a statement of 91.
        let (a, b) = ("a".repeat(40), "b".repeat(39));
        let comment = format!("// {}", ["word"; 18].join(" "));
        let src = format!("{comment}\nx = foo({a}, {b});\n");
        assert_eq!(at(100, &src), src);
        assert_eq!(
            at(80, &src),
            format!(
                "// {}\n// {}\nx = foo(\n    {a},\n    {b}\n);\n",
                ["word"; 15].join(" "),
                ["word"; 3].join(" ")
            )
        );
    }

    #[test]
    fn test_a_tab_of_indent_is_counted_as_four_columns() {
        let tabs = |src: &str| {
            crate::format_source_with(src, crate::IndentStyle::Tabs, DEFAULT_LINE_WIDTH).unwrap()
        };
        // 78 columns of text one level deep.
        let src = format!("f = {{\n\tx = foo({});\n\ty\n}};\n", "a".repeat(68));
        assert_eq!(
            tabs(&src),
            format!(
                "f = {{\n\tx = foo(\n\t\t{}\n\t);\n\ty\n}};\n",
                "a".repeat(68)
            )
        );
        // 77 columns of text one level deep: 81 with the indent.
        let (a, b) = ("a".repeat(36), "b".repeat(25));
        assert_eq!(
            tabs(&format!(
                "f = {{\n\tif (c) {{ {a} }} {{ {b} }};\n\ty\n}};\n"
            )),
            format!("f = {{\n\tif (c) {{\n\t\t{a}\n\t}} {{\n\t\t{b}\n\t}};\n\ty\n}};\n")
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
        // All of them on one line would be too wide, and each on its own
        // is not.
        let (a, b) = ("a".repeat(40), "b".repeat(40));
        assert_eq!(
            format(&format!("f({a}, {b})\n")),
            format!("f(\n    {a},\n    {b}\n)\n")
        );
        // Hand-wrapped over two lines, it comes out the same.
        assert_eq!(
            format(
                "var relay = super.newCopyArgs(name, Medium.default, TempoClock.default, MBState.new, false, List.new,\n    List.new, IdentityDictionary.new, false, nil, nil, Dictionary.new, List.new);\n"
            ),
            "var relay = super.newCopyArgs(\n    name,\n    Medium.default,\n    TempoClock.default,\n    MBState.new,\n    false,\n    List.new,\n    List.new,\n    IdentityDictionary.new,\n    false,\n    nil,\n    nil,\n    Dictionary.new,\n    List.new\n);\n"
        );
        // An argument too wide for its own line that is a chain breaks
        // before its operators, level with it.
        assert_layout(
            "unixCmd(\n    theProgramToRun\n    + \" -N\"\n    + theFileOfTheScore.quote\n    + theFileOfTheOutput.quote\n    + theOptionsOfTheServer.asOptionsString,\n    action\n);\n",
        );
        assert_layout(
            "x = [\n    firstElementOfAll,\n    rect.width\n    - labelBounds.width\n    - unitBounds.width\n    - numBounds.width\n    - gap1.x\n    - gap2.x\n    - gap3.x\n];\n",
        );
        // An argument too wide for its own line is opened in its turn.
        assert_layout(
            "serve.(\n    MBAddress.format(\n        \\here, someLongName, anotherLongArgument, yetAnotherOne, andOneMoreStill\n    ),\n    anotherArgument\n);\n",
        );
    }

    #[test]
    fn test_of_the_brackets_on_a_line_the_last_that_leaves_its_line_within_80_is_opened() {
        // (With one message after the call: two would be a chain of
        // messages, which breaks before its dots.)
        assert_eq!(
            format(
                "q = StaticText(n, n.bounds.moveTo(0, 0).insetBy(25)).string_(labels[index], \\center);\n"
            ),
            "q = StaticText(n, n.bounds.moveTo(0, 0).insetBy(25)).string_(\n    labels[index], \\center\n);\n"
        );
        // The second call's parenthesis is past column 80: opening it would
        // leave the line as wide as it was.
        let (a, b) = ("a".repeat(35), "b".repeat(35));
        assert_eq!(
            format(&format!("x = foo({a}, {b}).bar(c);\n")),
            format!("x = foo(\n    {a}, {b}\n).bar(c);\n")
        );
        // Brackets that hold nothing are not opened.
        assert_eq!(
            format(&format!("x = foo({a}, {b}).bar();\n")),
            format!("x = foo(\n    {a}, {b}\n).bar();\n")
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
        assert_eq!(
            format(
                "x = this.someMethod(firstOperandOfTheChain + secondOperandOfTheChain - thirdOperandOfTheChain * fourthOperand);\n"
            ),
            "x = this.someMethod(\n    firstOperandOfTheChain\n    + secondOperandOfTheChain\n    - thirdOperandOfTheChain\n    * fourthOperand\n);\n"
        );
        // Opened, the parentheses leave the chain no narrower, but it can
        // then be broken; and a block likewise.
        assert_eq!(
            format(
                "f = {\n    ^((this.prune(inMin, inMax, clip) - inMin) / (inMax - inMin) * (outMax - outMin) + outMin)\n};\n"
            ),
            "f = {\n    ^(\n        (this.prune(inMin, inMax, clip) - inMin)\n        / (inMax - inMin)\n        * (outMax - outMin)\n        + outMin\n    )\n};\n"
        );
        assert_eq!(
            format(
                "x = [1, { ((key == keyPlus) && modifier) || ((key == keyK) && mods.isShift) || (aaa + bbb) }];\n"
            ),
            "x = [\n    1,\n    {\n        ((key == keyPlus) && modifier)\n            || ((key == keyK) && mods.isShift)\n            || (aaa + bbb)\n    }\n];\n"
        );
        // An assignment between parentheses is no chain.
        assert_eq!(
            format(
                "this.someMethod(target.value = firstOperandOfTheChain + secondOperandOfTheChain + thirdOperandOfTheChain);\n"
            ),
            "this.someMethod(\n    target.value = firstOperandOfTheChain + secondOperandOfTheChain + thirdOperandOfTheChain\n);\n"
        );
    }

    #[test]
    fn test_an_array_and_an_event_are_opened_like_an_argument_list() {
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
        // An array of plain things is no different: on one line between
        // its brackets when it fits there, and one to a line when not.
        assert_eq!(
            format(
                "x = [\\alpha, \\beta, \\gamma, \\delta, \\epsilon, \\zeta, \\eta, \\theta, \\iota, \\kappa];\n"
            ),
            "x = [\n    \\alpha, \\beta, \\gamma, \\delta, \\epsilon, \\zeta, \\eta, \\theta, \\iota, \\kappa\n];\n"
        );
        assert_eq!(
            format(&format!("x = [{}];\n", ["100000"; 12].join(", "))),
            format!("x = [\n{}\n];\n", ["    100000"; 12].join(",\n"))
        );
        // The array is opened, and the block in it, still too wide on its
        // own line, then.
        let long = "a".repeat(72);
        assert_eq!(
            format(&format!("x = [1, 2, {{ |a| {long} }}, 4];\n")),
            format!("x = [\n    1,\n    2,\n    {{ |a|\n        {long}\n    }},\n    4\n];\n")
        );
    }

    #[test]
    fn test_a_list_whose_last_item_is_followed_by_a_comma_stays_open() {
        assert_layout("x = [\n    1,\n    2,\n];\n");
        assert_eq!(
            format("x = [1, 2, 3,];\n"),
            "x = [\n    1,\n    2,\n    3,\n];\n"
        );
        assert_eq!(format("x = [\n    1,\n    2\n];\n"), "x = [1, 2];\n");
        assert_layout("x = [\n    1,\n];\n");
        assert_eq!(
            format("x = [\n    \\freq,\n    440,\n    \\amp,\n    0.1,\n    \n];\n"),
            "x = [\n    \\freq, 440,\n    \\amp, 0.1,\n];\n"
        );
    }

    #[test]
    fn test_keys_and_values_share_a_line() {
        assert_eq!(
            format(
                "Pbind(\\instrument, \\default, \\freq, Pseq([440, 550, 660], inf), \\dur, 0.25, \\amp, 0.1, \\pan, 0).play;\n"
            ),
            "Pbind(\n    \\instrument, \\default,\n    \\freq, Pseq([440, 550, 660], inf),\n    \\dur, 0.25,\n    \\amp, 0.1,\n    \\pan, 0\n).play;\n"
        );
        assert_eq!(
            format(&format!(
                "x = [\\pitchA, 1, \\letinA, 1, \\other, {}];\n",
                "a".repeat(60)
            )),
            format!(
                "x = [\n    \\pitchA, 1,\n    \\letinA, 1,\n    \\other, {}\n];\n",
                "a".repeat(60)
            )
        );
        // One key and one value are two arguments like any others.
        assert_eq!(
            format(&format!(
                "Synth(\\name, {}, {});\n",
                "a".repeat(40),
                "b".repeat(40)
            )),
            format!(
                "Synth(\n    \\name,\n    {},\n    {}\n);\n",
                "a".repeat(40),
                "b".repeat(40)
            )
        );
        assert_eq!(
            format(&format!("Synth(\\name, {});\n", "a".repeat(80))),
            format!("Synth(\n    \\name,\n    {}\n);\n", "a".repeat(80))
        );
    }

    #[test]
    fn test_a_switch_keeps_its_value_on_its_line_and_gives_each_test_and_block_one() {
        assert_eq!(
            format(
                "switch (x, 0, { \"zero\".postln }, 1, { \"one\".postln }, 2, { \"two\".postln }, { \"other\".postln });\n"
            ),
            "switch (x,\n    0, { \"zero\".postln },\n    1, { \"one\".postln },\n    2, { \"two\".postln },\n    { \"other\".postln }\n);\n"
        );
        assert_eq!(
            format("switch (x, 0, { a.value; b.value }, { c });\n"),
            "switch (x,\n    0, {\n        a.value;\n        b.value\n    },\n    { c }\n);\n"
        );
        assert_layout("switch (x, 0, { a }, { b });\n");
        // Written with blocks, and a case.
        assert_eq!(
            format(
                "f = { switch (z) { 0 } { \"zero\".postln } { 1 } { \"one\".postln } { 2 } { \"two\".postln } { \"other\".postln } };\n"
            ),
            "f = {\n    switch (z)\n        { 0 } { \"zero\".postln }\n        { 1 } { \"one\".postln }\n        { 2 } { \"two\".postln }\n        { \"other\".postln }\n};\n"
        );
        let long = "a".repeat(76);
        assert_eq!(
            format(&format!(
                "x = case\n{{ a }} {{ b }}\n{{ c }} {{ {long} }};\n"
            )),
            format!("x = case\n    {{ a }} {{ b }}\n    {{ c }} {{\n        {long}\n    }};\n")
        );
        assert_layout("x = case { a } { b } { c } { d };\n");
    }

    #[test]
    fn test_a_block_that_is_the_last_argument_hugs_its_call() {
        assert_layout(
            "SynthDef(\\x, { |out|\n    var sig = SinOsc.ar;\n    Out.ar(out, sig)\n}).add;\n",
        );
        assert_layout("me.on('/here/*', { |msg|\n    first.(msg);\n    second.(msg)\n});\n");
        assert_layout("Routine({\n    a.wait;\n    b.value\n}).play;\n");
        assert_layout(
            "Button(parent, bounds).action_({ |button|\n    first.(button);\n    second.(button)\n});\n",
        );
        assert_layout("x.sched(0.5, action: { |time|\n    first.(time);\n    nil\n});\n");
        // One statement, too wide for the line.
        assert_eq!(
            format(
                "me.on('/here/*', { |msg| if (keys[msg.source].notNil) { watch.(msg.source, msg.values) } });\n"
            ),
            "me.on('/here/*', { |msg|\n    if (keys[msg.source].notNil) { watch.(msg.source, msg.values) }\n});\n"
        );
    }

    #[test]
    fn test_a_block_does_not_hug_when_it_is_not_last_or_not_the_only_block_or_its_line_is_too_wide()
    {
        // Not the last argument.
        assert_layout(
            "foo(\n    a,\n    { |x|\n        first.(x);\n        second.(x)\n    },\n    b\n);\n",
        );
        // Another argument is a block.
        assert_layout(
            "var made = me.once(\n    \\made, { IdentityDictionary.new }, { |relays| relays.do(_.free) }\n);\n",
        );
        assert_layout(
            "x.either(\n    { a },\n    { |x|\n        first.(x);\n        second.(x)\n    }\n);\n",
        );
        // The brace's line is too wide.
        assert_layout(
            "serve.(\n    MBAddress.format(\n        \\here, someLongName, anotherLongArgument, yetAnotherOne, andOneMoreStill\n    ),\n    { |msg|\n        first.(msg);\n        second.(msg)\n    }\n);\n",
        );
    }

    #[test]
    fn test_a_line_break_beside_a_comment_stays_and_opens_what_holds_it() {
        assert_stays("x = foo(\n    a,  // why\n    b\n);\n");
        assert_eq!(
            format("x = foo(a, // why\n    b);\n"),
            "x = foo(\n    a,  // why\n    b\n);\n"
        );
        assert_eq!(
            format("x = foo(a,\n    // why\n    b, c);\n"),
            "x = foo(\n    a,\n    // why\n    b,\n    c\n);\n"
        );
        assert_stays("foo(\n    bar(\n        a  // why\n    )\n)\n");
        assert_stays("x = a  // why\n    + b\n    + c;\n");
        assert_stays("var a,  // the first\n    b;  // the second\n");
        assert_stays("a.value;  // call it (now)\n{ 1 }.value;\n");
        assert_stays("a.value; /* x = */\n{ 1 }.value;\n");
        assert_stays("a.  // why\nb;\n");
        // Where only what must be open keeps a line from standing whole,
        // that is what is opened, and no block after it.
        assert_stays("try({\n    a.value;  // why\n    b\n}) { c };\n");
        // A comment in the middle of a line opens what holds it too, and
        // goes with what follows it.
        assert_eq!(
            format("x = foo(a, /* why */ b);\n"),
            "x = foo(\n    a,\n    /* why */ b\n);\n"
        );
        assert_eq!(
            format("x = (\n    a: 1, /*c*/ b: 2,\n    c: 3\n);\n"),
            "x = (\n    a: 1,\n    /*c*/ b: 2,\n    c: 3\n);\n"
        );
        assert_eq!(
            format("x = a /* why */ + b;\n"),
            "x = a /* why */\n    + b;\n"
        );
        assert_eq!(
            format("var a /* why */, b;\n"),
            "var a /* why */,\n    b;\n"
        );
        // Where nothing that can be opened holds it, it stays in its line.
        assert_layout("x = /* why */ foo(a, b);\n");
        assert_eq!(
            format(
                "x = foo(firstArgumentOfAll, /* why */ secondArgumentOfAll, thirdArgumentOfAll, fourthArgumentOfAll);\n"
            ),
            "x = foo(\n    firstArgumentOfAll,\n    /* why */ secondArgumentOfAll,\n    thirdArgumentOfAll,\n    fourthArgumentOfAll\n);\n"
        );
    }

    #[test]
    fn test_what_cannot_be_broken_or_is_no_narrower_broken_stays_wide() {
        for src in [
            // A string, and a call that would only move it four columns in.
            "x = \"a string that is much too long for its line but cannot be broken, being a string\";\n",
            "f(\"a string that is much too long for its line but cannot be broken, being a string, at all\");\n",
            // A line that is too wide only with the comment that ends it.
            "x = foo(a, b);  // a comment that takes the line over eighty columns, at its end, and stays\n",
        ] {
            assert_eq!(format(src), src);
        }
    }
}
