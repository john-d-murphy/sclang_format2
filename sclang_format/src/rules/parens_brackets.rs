// src/rules/parens_brackets.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

const fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
}

/// Check if byte position is inside a string or comment node
fn in_string_or_comment(root: Node, byte: usize) -> bool {
    let mut cur = root.descendant_for_byte_range(byte, byte + 1);
    while let Some(n) = cur {
        match n.kind() {
            "comment" | "block_comment" | "line_comment" | "string" => return true,
            _ => {}
        }
        cur = n.parent();
    }
    false
}

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
        let src = cx.bytes();
        let bytes: &[u8] = &src;
        let len = bytes.len();
        let root = cx.tree.root_node();

        let mut edits = Vec::new();

        for i in 0..len {
            let b = bytes[i];

            match b {
                b'(' | b'[' => {
                    // Skip if inside string or comment
                    if in_string_or_comment(root, i) {
                        continue;
                    }

                    // Find end of whitespace run after delimiter
                    let mut j = i + 1;
                    while j < len && is_space(bytes[j]) && !is_newline(bytes[j]) {
                        j += 1;
                    }

                    // Only remove if there's whitespace to remove
                    if j > i + 1 {
                        // Don't remove if followed by a comment
                        if j < len && comment_starts_at(root, j) {
                            continue;
                        }

                        edits.push(TextEdit {
                            start_byte: i + 1,
                            end_byte: j,
                            replacement: String::new(),
                        });
                    }
                }
                b')' | b']' => {
                    // Skip if inside string or comment
                    if in_string_or_comment(root, i) {
                        continue;
                    }

                    // Find start of whitespace run before delimiter
                    let mut j = i;
                    while j > 0 && is_space(bytes[j - 1]) && !is_newline(bytes[j - 1]) {
                        j -= 1;
                    }

                    // Only remove if there's whitespace to remove
                    if j < i {
                        edits.push(TextEdit {
                            start_byte: j,
                            end_byte: i,
                            replacement: String::new(),
                        });
                    }
                }
                _ => {}
            }
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::engine::{Ctx, IndentStyle};
    use crate::grammar;

    fn format(src: &str) -> String {
        let mut cx = Ctx::new(
            src.to_string(),
            grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        let rule = ParenBracketSpacing;
        rule.run(&mut cx).unwrap();
        cx.to_string()
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
            "Should preserve space before comment, got: {}",
            result
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
            "Should not remove all space before comment, got: {}",
            result
        );
    }

    #[test]
    fn test_preserves_space_before_block_comment() {
        let input = "(  /* comment */ foo)";
        let result = format(input);
        // Should preserve space before block comment
        assert!(
            result.contains("(  /*"),
            "Should preserve space before block comment, got: {}",
            result
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
