// src/engine/ast_utils.rs
//! The brackets the tree holds, and how deep a line stands among them.
//!
//! `break_lines` lays code out and `indent_by_ast_level` indents what it
//! made. Both ask here what a pair of brackets is and where a chain of
//! operators or a list of declarations runs on, so that the one measures a
//! line at the depth the other gives it.

use crate::engine::text::is_space;
use tree_sitter::Node;

/// A pair of brackets that can be opened: what stands between them put on
/// lines of its own, one level in, and the closing one on the line after.
#[derive(Clone, Copy)]
pub struct Brackets<'a> {
    pub open: Node<'a>,
    /// The last thing that stays on the opening bracket's line: the bracket
    /// itself, or the parameters of a block.
    pub head: Node<'a>,
    pub close: Node<'a>,
}

impl<'a> Brackets<'a> {
    /// What stands between the brackets, after the parameters of a block,
    /// comments and all.
    #[must_use]
    pub fn contents(&self) -> Vec<Node<'a>> {
        std::iter::successors(self.head.next_sibling(), Node::next_sibling)
            .take_while(|n| n.id() != self.close.id())
            .collect()
    }

    /// Whether they are opened: what follows the opening bracket's line
    /// begins a later one.
    #[must_use]
    pub fn are_open(&self) -> bool {
        let first = std::iter::successors(self.head.next_sibling(), Node::next_sibling)
            .find(|n| !is_comment(*n));
        first.is_some_and(|n| n.start_position().row > self.head.end_position().row)
    }

    /// Whether `byte` stands between them, the closing bracket apart.
    #[must_use]
    pub fn hold(&self, byte: usize) -> bool {
        self.open.end_byte() <= byte && byte < self.close.start_byte()
    }
}

#[must_use]
pub fn is_comment(node: Node) -> bool {
    matches!(node.kind(), "line_comment" | "block_comment")
}

/// The brackets of `node`, when it has a pair that can be opened.
///
/// Those are a block's, a call's or a control structure's parentheses,
/// those that group, an event's, an array's, an index's, and the braces of
/// a class's body.
#[must_use]
pub fn brackets_of(node: Node) -> Option<Brackets> {
    let (opening, closing) = match node.kind() {
        "function_block" | "class_def" => ("{", "}"),
        "function_call"
        | "method_call"
        | "apply_call"
        | "instance_variable_setter_call"
        | "if"
        | "while"
        | "for"
        | "forby"
        | "switch"
        | "code_block"
        | "event" => ("(", ")"),
        "collection" | "indexed_collection" => ("[", "]"),
        _ => return None,
    };
    let mut cursor = node.walk();
    let open = node.children(&mut cursor).find(|n| n.kind() == opening)?;
    // The bracket that closes it is the node's last child, or, where
    // blocks follow a call's parentheses, the first of its kind.
    let last = node.child(node.child_count() - 1)?;
    let close = if last.kind() == closing {
        last
    } else {
        std::iter::successors(open.next_sibling(), Node::next_sibling)
            .find(|n| n.kind() == closing)?
    };
    let head = open
        .next_sibling()
        .filter(|n| n.kind() == "parameter_list")
        .unwrap_or(open);
    Some(Brackets { open, head, close })
}

/// Whether `node` is the parentheses around a region of a file: what the
/// interpreter runs as one. Its lines stand as deep as the parentheses.
#[must_use]
pub fn is_region(node: Node) -> bool {
    node.kind() == "code_block" && node.parent().is_some_and(|p| p.kind() == "source_file")
}

/// Whether `node` is a link of a chain of operators.
///
/// The operators are the binary ones, the keyword messages, and those
/// that ask for nil. An assignment to what a message names (`a.b = c`) is
/// written with an operator and is no link.
#[must_use]
pub fn is_chain(node: Node) -> bool {
    match node.kind() {
        "nil_check" => true,
        "binary_expression" => operator_of(node).is_some_and(|op| op.kind() != "="),
        _ => false,
    }
}

/// The operator of one link of a chain.
#[must_use]
pub fn operator_of(node: Node) -> Option<Node> {
    node.child_by_field_name("operator").or_else(|| {
        let mut cursor = node.walk();
        node.children(&mut cursor)
            .find(|n| matches!(n.kind(), "?" | "??" | "!?"))
    })
}

/// Whether `node` goes on with the expression its child `part` is of:
/// it is a link of a chain, or a message to what `part` is, and `part`
/// does not stand between its brackets.
///
/// The tree reads `a + b.c(d)` as `(a + b).c(d)`, which sclang does not:
/// the operators of a chain are found through the messages that the tree
/// hangs on it.
fn goes_on_with(node: Node, part: Node) -> bool {
    let carries = is_chain(node)
        || matches!(
            node.kind(),
            "function_call" | "method_call" | "indexed_collection"
        );
    carries && !brackets_of(node).is_some_and(|b| b.hold(part.start_byte()))
}

/// The operators of the chain that the expression `whole` is, in order:
/// those that stand in it outside every pair of brackets. None, when it
/// is no chain.
///
/// sclang has no precedence among binary operators, and the tree nests
/// them any way: the chain is every one of them.
#[must_use]
pub fn operators_of(whole: Node) -> Vec<Node> {
    let mut operators = Vec::new();
    let mut pending = vec![whole];
    while let Some(node) = pending.pop() {
        if is_chain(node) {
            operators.extend(operator_of(node));
        }
        let mut cursor = node.walk();
        pending.extend(
            node.children(&mut cursor)
                .filter(|part| goes_on_with(node, *part) && goes_on_with(*part, *part)),
        );
    }
    operators.sort_by_key(Node::start_byte);
    operators
}

/// Whether `chain` is an item between a pair of parentheses or brackets:
/// all that stands between them, or one of the things their commas part.
///
/// Such a chain breaks level with its first operand: the brackets have
/// indented it already. A block, a region of a file and parentheses with
/// semicolons between them hold statements, and a chain that is one runs
/// on like any other.
#[must_use]
pub fn is_item_between_brackets(chain: Node) -> bool {
    let holder = std::iter::successors(chain.parent(), Node::parent)
        .find(|n| !matches!(n.kind(), "unnamed_argument" | "argument_calls"))
        .filter(|n| n.kind() != "function_block" && !is_region(*n))
        .and_then(|n| {
            if n.kind() == "parameter_call_list" {
                n.parent()
            } else {
                Some(n)
            }
        });
    holder.and_then(brackets_of).is_some_and(|brackets| {
        let holds_statements = brackets
            .contents()
            .iter()
            .any(|n| matches!(n.kind(), ";" | "variable_definition_sequence"));
        brackets.hold(chain.start_byte()) && !holds_statements
    })
}

/// The blocks of a `case`, or of a `switch` written with blocks, when it
/// has a test and a block at least: each test and its block get a line.
#[must_use]
pub fn cases_of(node: Node) -> Option<Vec<Node>> {
    if !matches!(node.kind(), "case" | "switch") {
        return None;
    }
    let mut cursor = node.walk();
    let blocks: Vec<Node> = node
        .children(&mut cursor)
        .filter(|n| n.kind() == "function_block")
        .collect();
    let first = blocks.first()?.start_byte();
    let between_parentheses = brackets_of(node).is_some_and(|b| b.hold(first));
    (blocks.len() > 1 && !between_parentheses).then_some(blocks)
}

/// Whether `node` begins its line.
#[must_use]
pub fn begins_line(node: Node, src: &[u8]) -> bool {
    let before = src[..node.start_byte()].iter().rposition(|&b| !is_space(b));
    before.is_none_or(|i| src[i] == b'\n')
}

/// Whether `byte` stands after `comma`, the first of a list, in a list
/// that runs on: what follows the comma stands on a later line.
fn runs_on_after(comma: Node, byte: usize) -> bool {
    comma.end_byte() <= byte
        && std::iter::successors(comma.next_sibling(), Node::next_sibling)
            .find(|n| !is_comment(*n))
            .is_some_and(|n| n.start_position().row > comma.end_position().row)
}

/// How many levels `node` puts `byte`, which it holds, in. `below` is the
/// child of `node` that holds `byte`.
fn levels(node: Node, below: Option<Node>, byte: usize, src: &[u8]) -> usize {
    let mut levels = 0;
    // What stands between brackets that are opened is one level in. The
    // lines of a region are not.
    if let Some(brackets) = brackets_of(node)
        && brackets.hold(byte)
        && brackets.are_open()
        && !is_region(node)
    {
        levels += 1;
    }
    match node.kind() {
        // The lines a chain runs on over are one level in, from its first
        // operator.
        _ if goes_on_with(node, node) && !node.parent().is_some_and(|p| goes_on_with(p, node)) => {
            let operators = operators_of(node);
            let runs_on = operators.first().is_some_and(|op| op.start_byte() <= byte)
                && operators.into_iter().any(|op| begins_line(op, src))
                && !is_item_between_brackets(node);
            levels += usize::from(runs_on);
        }
        // So are the declarations after the first, when each has a line,
        // and the comments that stand among them.
        "variable_definition_sequence" => {
            let mut cursor = node.walk();
            let comma = node.children(&mut cursor).find(|n| n.kind() == ",");
            levels += usize::from(comma.is_some_and(|comma| runs_on_after(comma, byte)));
        }
        // And those of a class, whose declarations are its own children.
        "class_def" if below.is_some_and(|n| n.kind() != "function_block") => {
            let mut first_comma = None;
            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                if child.start_byte() > byte {
                    break;
                }
                match child.kind() {
                    ";" | "{" => first_comma = None,
                    "," => first_comma = first_comma.or(Some(child)),
                    _ => {}
                }
            }
            levels += usize::from(first_comma.is_some_and(|comma| runs_on_after(comma, byte)));
        }
        // A switch between parentheses keeps the value it switches on on
        // its first line, and what follows the comma is one level in.
        "switch" | "case" => {
            let mut cursor = node.walk();
            let comma = node.children(&mut cursor).find(|n| n.kind() == ",");
            let inside = brackets_of(node).is_some_and(|b| b.hold(byte) && !b.are_open());
            levels += usize::from(inside && comma.is_some_and(|comma| runs_on_after(comma, byte)));
            // Written with blocks, each test and its block is one level
            // in when they have lines of their own.
            if let Some(blocks) = cases_of(node)
                && blocks[0].start_byte() <= byte
                && begins_line(blocks[0], src)
            {
                levels += 1;
            }
        }
        _ => {}
    }
    levels
}

/// How deep the line that begins at `byte` stands: one level for each pair
/// of opened brackets around it, and one where a chain or a list of
/// declarations runs on.
#[must_use]
pub fn depth_at(root: Node, byte: usize, src: &[u8]) -> usize {
    let Some(mut node) = root.descendant_for_byte_range(byte, byte + 1) else {
        return 0;
    };
    let mut depth = 0;
    let mut below = None;
    loop {
        depth += levels(node, below, byte, src);
        let Some(parent) = node.parent() else {
            return depth;
        };
        below = Some(node);
        node = parent;
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use tree_sitter::Parser;

    /// The depth of each line of `src`, which is written with the indent
    /// its depth gives it.
    fn depths(src: &str) -> Vec<usize> {
        let mut parser = Parser::new();
        parser.set_language(&crate::grammar::language()).unwrap();
        let tree = parser.parse(src, None).unwrap();
        assert!(!tree.root_node().has_error(), "{src}");
        let mut depths = Vec::new();
        let mut start = 0;
        for line in src.split_inclusive('\n') {
            let first = start + line.len() - line.trim_start().len();
            if !line.trim().is_empty() {
                depths.push(depth_at(tree.root_node(), first, src.as_bytes()));
            }
            start += line.len();
        }
        depths
    }

    /// The depths the indents of `src` say.
    fn written(src: &str) -> Vec<usize> {
        src.lines()
            .filter(|line| !line.trim().is_empty())
            .map(|line| (line.len() - line.trim_start().len()) / 4)
            .collect()
    }

    #[test]
    fn what_opened_brackets_hold_is_one_level_in() {
        for src in [
            "x = {\n    1\n};\n",
            "x = { |a|\n    a;\n    b\n}.value;\n",
            "x = foo(\n    1, 2\n);\n",
            "x = foo(\n    [\n        1,\n        2\n    ],\n    (\n        a: 1\n    )\n);\n",
            "x = (\n    a + b\n) * c[\n    1\n];\n",
            "if (\n    a\n) {\n    b\n} {\n    c\n};\n",
            "Foo {\n    bar { |a|\n        ^a\n    }\n}\n",
            "f = { // why\n    1\n};\n",
            "f = {\n    // nothing\n};\n",
        ] {
            assert_eq!(depths(src), written(src), "{src}");
        }
    }

    #[test]
    fn a_region_of_a_file_is_not_indented_and_one_in_it_is() {
        for src in [
            "(\nvar a = 1;\nx = {\n    a\n};\n)\n",
            "(\n(\n    a;\n    b\n);\n)\n",
        ] {
            assert_eq!(depths(src), written(src), "{src}");
        }
    }

    #[test]
    fn brackets_that_are_not_opened_indent_nothing() {
        // A block that hugs its call: the parentheses are not opened.
        for src in [
            "foo(a, { |x|\n    x\n});\n",
            "foo(bar(\n    1\n), { |x|\n    x\n});\n",
        ] {
            assert_eq!(depths(src), written(src), "{src}");
        }
    }

    #[test]
    fn a_chain_that_runs_on_is_one_level_in_and_one_between_brackets_is_not() {
        for src in [
            "x = a\n    + b\n    - c;\n",
            "x = a\n    + b.c(d)\n    + e;\n",
            "x = a\n    << b.c { |y|\n        y;\n        z\n    }\n    << e.f(\n        g\n    );\n",
            "a\n    and: { b }\n    and: {\n        c;\n        d\n    };\n",
            "^a\n    ?? { b };\n",
            "x.y = a\n    * b;\n",
            "x = foo(\n    a\n) + b;\n",
            "if (\n    a\n    and: { b }\n) { c };\n",
            "x = (\n    a\n    + b\n) * c;\n",
            "foo(\n    a\n    + b,\n    c\n    - d\n);\n",
            "x = [\n    a\n    + b.c(\n        d\n    ),\n    e\n];\n",
            "x = (\n    a\n        + b;\n    c\n);\n",
            "f = {\n    a\n        + b\n};\n",
        ] {
            assert_eq!(depths(src), written(src), "{src}");
        }
    }

    #[test]
    fn declarations_after_the_first_are_one_level_in() {
        for src in [
            "var a = 1,\n    b = foo(\n        2\n    ),\n    c;\n",
            "var a = {\n    1\n};\n",
            "Foo {\n    var a,\n        b = 2;\n    classvar c;\n    foo { ^a }\n}\n",
        ] {
            assert_eq!(depths(src), written(src), "{src}");
        }
    }

    #[test]
    fn the_tests_of_a_switch_and_of_a_case_are_one_level_in() {
        for src in [
            "switch (x,\n    0, { a },\n    1, {\n        b;\n        c\n    },\n    { d }\n);\n",
            "switch (x)\n    { 0 } { a }\n    { 1 } {\n        b;\n        c\n    }\n    { d };\n",
            "x = case\n    { a } { b }\n    { c } { d };\n",
            "case\n    { a } {\n        b;\n        c\n    };\n",
        ] {
            assert_eq!(depths(src), written(src), "{src}");
        }
    }
}
