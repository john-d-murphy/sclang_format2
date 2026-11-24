use crate::engine::ast_utils::{is_comment, is_region};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

/// Takes away the line breaks inside a statement.
///
/// How code is laid out is decided by the code, not by the lines it was
/// typed on. `break_lines` then breaks what is left where the layout says,
/// so that the same tokens come out the same however they were typed.
///
/// What stays is the writer's: a line break (and the blank lines with it)
/// between two statements, between the members of a class, at the edges of
/// a region of a file and of a class's body, and beside a comment, which
/// keeps its line, or the end of the line it is on. The inside of a string
/// is never looked at.
///
/// A blank stands in for each break taken away (none inside a parenthesis
/// or a bracket), and the rules for spacing, which run after this one, make
/// of it what they make of any blank.
pub struct JoinLines;

impl Rule for JoinLines {
    fn name(&self) -> &'static str {
        "join_lines"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let mut edits = Vec::new();
        let mut before = None;
        collect(cx.bytes(), cx.tree.root_node(), &mut before, &mut edits);
        let n = edits.len();
        cx.apply_edits(edits)?;
        Ok(n)
    }
}

/// Walks the tokens under `node` in order, and joins each to the one
/// `before` it when a line break that is nobody's stands between them.
fn collect<'a>(
    bytes: &[u8],
    node: Node<'a>,
    before: &mut Option<Node<'a>>,
    edits: &mut Vec<TextEdit>,
) {
    // A string, a symbol and a character are one token each, whatever
    // they hold.
    let is_token = node.child_count() == 0 || matches!(node.kind(), "string" | "symbol" | "char");
    if !is_token {
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            collect(bytes, child, before, edits);
        }
        return;
    }
    if let Some(prev) = before.replace(node) {
        let (from, to) = (prev.end_byte(), node.start_byte());
        let joins = from < to
            && bytes[from..to].contains(&b'\n')
            && !is_comment(prev)
            && !is_comment(node)
            && !begins_a_line_of_its_own(node);
        if joins {
            // No blank stands inside parentheses and brackets, nor between
            // braces that hold nothing: `paren_bracket_spacing` would only
            // take it away again.
            let closed_up = matches!(prev.kind(), "(" | "[")
                || matches!(node.kind(), ")" | "]")
                || (prev.kind(), node.kind()) == ("{", "}");
            edits.push(TextEdit {
                start_byte: from,
                end_byte: to,
                replacement: if closed_up { "" } else { " " }.to_string(),
            });
        }
    }
}

/// Whether the line break before `token` is the writer's: `token` begins a
/// statement after another, or a member of a class, or stands at an edge
/// of a region or of a class's body.
fn begins_a_line_of_its_own(token: Node) -> bool {
    // What `token` begins: the largest node that starts where it does.
    let mut node = token;
    while let Some(parent) = node
        .parent()
        .filter(|p| p.start_byte() == token.start_byte())
    {
        node = parent;
    }
    let (Some(holder), Some(above)) = (node.parent(), node.prev_sibling()) else {
        // The first thing in the file, or in what holds it.
        return true;
    };
    let ends_a_statement = matches!(above.kind(), ";" | "variable_definition_sequence");
    match holder.kind() {
        // A semicolon is the end of its statement, wherever it was typed.
        _ if node.kind() == ";" => false,
        "source_file" => true,
        "code_block" if is_region(holder) => true,
        "function_block" | "code_block" => ends_a_statement && !matches!(node.kind(), "}" | ")"),
        "class_def" => matches!(above.kind(), "{" | ";" | "function_block") || node.kind() == "}",
        _ => false,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::engine::IndentStyle;
    use crate::grammar;

    fn join(src: &str) -> String {
        let mut cx = Ctx::new(
            src.to_string(),
            &grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        JoinLines.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_the_line_breaks_inside_a_statement_are_taken_away() {
        for (src, want) in [
            ("x = foo(a,\n    b\n);", "x = foo(a, b);"),
            ("x = [\n    1,\n\n    2\n];", "x = [1, 2];"),
            ("f =\n{\n    |a|\n    a\n};", "f = { |a| a };"),
            ("if (a)\n{\n    b\n}\n{\n    c\n};", "if (a) { b } { c };"),
            ("x = a\n    .b\n    .c;", "x = a .b .c;"),
            ("x = a.\n    b;", "x = a. b;"),
            ("x = a +\n    b\n;", "x = a + b ;"),
            ("foo(\n);", "foo();"),
            ("x = [$ \n, 1];", "x = [$  , 1];"),
            ("x = \"a\nb\" ++\n\"c\";", "x = \"a\nb\" ++ \"c\";"),
        ] {
            assert_eq!(join(src), want);
        }
    }

    #[test]
    fn test_the_line_breaks_between_statements_stay_and_the_blank_lines() {
        for src in [
            "a = 1;\n\n\nb = 2;\nc = 3;",
            "f = { a;\n\n    b };",
            "f = { var a;\n    a };",
            "(\n\na = 1;\nb = 2;\n\n)",
            "x = (a;\n    b);",
            "Foo {\n\n    var a;\n    classvar b;\n\n    foo { ^a }\n    *bar { ^b }\n\n}",
        ] {
            assert_eq!(join(src), src);
        }
        // The edges of a block are no statement's, and of a class's body
        // are.
        assert_eq!(join("f = {\n    a;\n    b\n};"), "f = { a;\n    b };");
        assert_eq!(
            join("Foo\n{\n    var a,\n        b;\n    *new\n    {\n        ^a\n    }\n}"),
            "Foo {\n    var a, b;\n    *new { ^a }\n}"
        );
    }

    #[test]
    fn test_a_line_break_beside_a_comment_stays() {
        for src in [
            "x = foo(a, // why\n    b);",
            "x = foo(a,\n    // why\n    b);",
            "x = foo(a, /* why */\n    b);",
            "x = foo(a,\n    /* why */ b);",
        ] {
            assert_eq!(join(src), src);
        }
    }
}
