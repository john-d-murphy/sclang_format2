// src/rules/parens_brackets.rs

use crate::engine::ast::end_of_token_before;
use crate::engine::text::is_space;
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

/// Check if there's a comment node starting at or near the given byte position
fn comment_starts_at(root: Node, byte: usize) -> bool {
    if let Some(node) = root.descendant_for_byte_range(byte, byte + 1) {
        let kind = node.kind();
        if kind == "comment" || kind == "line_comment" || kind == "block_comment" {
            return true;
        }
    }
    false
}

pub struct ParenBracketSpacing;

impl Rule for ParenBracketSpacing {
    fn name(&self) -> &'static str {
        "paren_bracket_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let mut edits = Vec::new();
        collect(cx.bytes(), root, root, &mut edits);

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

/// Every parenthesis and bracket the tree holds under `node`. One in a
/// string, a symbol, a character or a comment is no token, and is not met.
fn collect(bytes: &[u8], root: Node, node: Node, edits: &mut Vec<TextEdit>) {
    match node.kind() {
        "(" | "[" => remove_blanks_after(bytes, root, node, edits),
        ")" | "]" => remove_blanks_before(bytes, node, edits),
        _ => {}
    }
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        collect(bytes, root, child, edits);
    }
}

fn remove_blanks_after(bytes: &[u8], root: Node, open: Node, edits: &mut Vec<TextEdit>) {
    let start = open.end_byte();
    let mut end = start;
    while end < bytes.len() && is_space(bytes[end]) {
        end += 1;
    }
    if end == start {
        return;
    }
    // Don't remove if followed by a comment
    if end < bytes.len() && comment_starts_at(root, end) {
        return;
    }
    // Don't remove whitespace in empty brackets/parens: [ ] or ( )
    if end < bytes.len() && (bytes[end] == b']' || bytes[end] == b')') {
        return;
    }
    edits.push(TextEdit {
        start_byte: start,
        end_byte: end,
        replacement: String::new(),
    });
}

fn remove_blanks_before(bytes: &[u8], close: Node, edits: &mut Vec<TextEdit>) {
    let end = close.start_byte();
    // As far back as the token before: the blank of the character `$ `, or
    // of `$\ `, is that token's.
    let token_end = end_of_token_before(close);
    let mut start = end;
    while start > token_end && is_space(bytes[start - 1]) {
        start -= 1;
    }
    if start == end {
        return;
    }
    // Don't remove whitespace in empty brackets/parens: [ ] or ( )
    if start > 0 && (bytes[start - 1] == b'[' || bytes[start - 1] == b'(') {
        return;
    }
    edits.push(TextEdit {
        start_byte: start,
        end_byte: end,
        replacement: String::new(),
    });
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::engine::{Ctx, IndentStyle};
    use crate::grammar;

    fn format(src: &str) -> String {
        let mut cx = Ctx::new(
            src.to_string(),
            &grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        let rule = ParenBracketSpacing;
        rule.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_a_bracket_in_a_character_a_symbol_or_a_string_is_not_one() {
        for src in [
            "x = [$( , $[ , 1];",
            "x = [1, $ ];",
            "x = [$\\n, $\\t, $\\ ];",
            "x = ['( a', \"[ b\", \\a];",
            "x = [$', 1]; y = ( 1 ); z = [$', 2];",
        ] {
            assert_eq!(format(src), src.replace("( 1 )", "(1)"));
        }
    }

    #[test]
    fn test_removes_space_after_open_paren() {
        assert_eq!(format("( foo )"), "(foo)");
    }

    #[test]
    fn test_removes_space_after_open_bracket() {
        assert_eq!(format("[ 1, 2 ]"), "[1, 2]");
    }

    #[test]
    fn test_removes_tabs_after_open_paren() {
        assert_eq!(format("(\tfoo\t)"), "(foo)");
    }

    #[test]
    fn test_preserves_newline_after_open_paren() {
        let input = "(\n    foo\n)";
        assert_eq!(format(input), input);
    }

    #[test]
    fn test_preserves_space_before_line_comment() {
        // This was causing idempotency failure
        let input = "(  // comment\nfoo\n)";
        let result = format(input);
        // Should NOT become "(// comment" - preserve space before comment
        assert!(
            result.contains("(  //"),
            "Should preserve space before comment, got: {result}"
        );
    }

    #[test]
    fn test_preserves_tab_before_line_comment() {
        // The EZNumber case: `(		// all features`
        let input = "(\t\t// all features\nfoo\n)";
        let result = format(input);
        // Should preserve the whitespace before comment
        assert!(
            !result.contains("(//"),
            "Should not remove all space before comment, got: {result}"
        );
    }

    #[test]
    fn test_preserves_space_before_block_comment() {
        let input = "(  /* comment */ foo)";
        let result = format(input);
        // Should preserve space before block comment
        assert!(
            result.contains("(  /*"),
            "Should preserve space before block comment, got: {result}"
        );
    }

    #[test]
    fn test_idempotency_paren_comment() {
        // Run twice, should get same result
        let input = "(\t\t// comment\nfoo\n)";
        let once = format(input);
        let twice = format(&once);
        assert_eq!(once, twice, "Must be idempotent");
    }

    #[test]
    fn test_idempotency_nested_paren_comment() {
        // The actual failing pattern from EZNumber
        let input = "(		// all features
		g=EZNumber(nil, 170@20);
)";
        let once = format(input);
        let twice = format(&once);
        assert_eq!(once, twice, "Must be idempotent");
    }

    #[test]
    fn test_does_not_touch_parens_in_string() {
        let input = "\"( foo )\"";
        assert_eq!(format(input), input);
    }

    #[test]
    fn test_does_not_touch_parens_in_comment() {
        let input = "// ( foo )";
        assert_eq!(format(input), input);
    }
}
