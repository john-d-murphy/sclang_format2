// src/rules/inline_comment_spacing.rs

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

/// Check if this byte position is the START of a line comment node
fn is_line_comment_start(root: Node, byte: usize) -> bool {
    if let Some(node) = root.descendant_for_byte_range(byte, byte + 2) {
        // Must be a comment node that starts at this exact position
        let kind = node.kind();
        if (kind == "comment" || kind == "line_comment") && node.start_byte() == byte {
            return true;
        }
    }
    false
}

pub struct InlineCommentSpacing;

impl Rule for InlineCommentSpacing {
    fn name(&self) -> &'static str {
        "inline_comment_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes();
        let bytes: &[u8] = &src;
        let len = bytes.len();
        let root = cx.tree.root_node();
        let mut edits: Vec<TextEdit> = Vec::new();

        let mut i = 0usize;
        while i + 1 < len {
            if bytes[i] == b'/' && bytes[i + 1] == b'/' {
                // Only process if this is the START of a comment node
                if !is_line_comment_start(root, i) {
                    i += 1;
                    continue;
                }

                // Find start of line.
                let mut line_start = i;
                while line_start > 0 && bytes[line_start - 1] != b'\n' {
                    line_start -= 1;
                }

                // Check if there's any non-space before the comment → inline.
                let mut j = line_start;
                let mut has_code_before = false;
                while j < i {
                    if !is_space(bytes[j]) {
                        has_code_before = true;
                        break;
                    }
                    j += 1;
                }

                if !has_code_before {
                    // Full-line `// foo` – we don't touch.
                    // Skip to end of line
                    while i < len && bytes[i] != b'\n' {
                        i += 1;
                    }
                    continue;
                }

                // 1) Exactly two spaces before `//`.
                let mut ws_start = i;
                while ws_start > line_start && is_space(bytes[ws_start - 1]) {
                    ws_start -= 1;
                }
                edits.push(TextEdit {
                    start_byte: ws_start,
                    end_byte: i,
                    replacement: "  ".to_string(),
                });

                // 2) At least one space after `//` if there's comment text.
                let after = i + 2;
                if after < len && !is_newline(bytes[after]) {
                    if bytes[after] == b' ' {
                        // fine
                    } else if bytes[after] == b'\t' {
                        // normalize tab to a single space
                        edits.push(TextEdit {
                            start_byte: after,
                            end_byte: after + 1,
                            replacement: " ".to_string(),
                        });
                    } else {
                        edits.push(TextEdit {
                            start_byte: after,
                            end_byte: after,
                            replacement: " ".to_string(),
                        });
                    }
                }

                // Skip to end of line - don't look for more // inside this comment
                while i < len && bytes[i] != b'\n' {
                    i += 1;
                }
            } else {
                i += 1;
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
        let rule = InlineCommentSpacing;
        rule.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_inline_comment_gets_two_spaces() {
        assert_eq!(format("foo;// comment"), "foo;  // comment");
        assert_eq!(format("foo;   // comment"), "foo;  // comment");
        assert_eq!(format("foo;\t// comment"), "foo;  // comment");
    }

    #[test]
    fn test_space_after_slashes() {
        assert_eq!(format("foo;  //comment"), "foo;  // comment");
        assert_eq!(format("foo;  //\tcomment"), "foo;  // comment");
    }

    #[test]
    fn test_full_line_comment_untouched() {
        let input = "// this is a full line comment";
        assert_eq!(format(input), input);
    }

    #[test]
    fn test_divider_line_untouched() {
        // The problematic pattern - // inside comment content
        let input = "//  //   //   //   //   //   //   // /";
        let result = format(input);
        assert_eq!(result, input, "Should not touch // inside comment content");
    }

    #[test]
    fn test_divider_line_idempotent() {
        let input = "//  //   //   //   //   //   //   // /";
        let once = format(input);
        let twice = format(&once);
        assert_eq!(once, twice, "Must be idempotent");
    }

    #[test]
    fn test_inline_comment_idempotent() {
        let input = "foo;  // comment";
        let once = format(input);
        let twice = format(&once);
        assert_eq!(once, twice, "Must be idempotent");
    }
}
