// src/rules/inline_comment_spacing.rs

use crate::engine::ast::{blanks_before, descendants_of_kind};
use crate::engine::text::{is_newline, is_space};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

/// Two spaces before a `//` comment that follows code on its line, and one
/// space after the slashes.
pub struct InlineCommentSpacing;

impl Rule for InlineCommentSpacing {
    fn name(&self) -> &'static str {
        "inline_comment_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let mut edits: Vec<TextEdit> = Vec::new();

        for comment in descendants_of_kind(cx.tree.root_node(), "line_comment") {
            let at = comment.start_byte();
            let line_start = bytes[..at]
                .iter()
                .rposition(|&b| b == b'\n')
                .map_or(0, |i| i + 1);
            // A comment with nothing but blanks before it on its line is a
            // line of its own, and is not touched.
            if bytes[line_start..at].iter().all(|&b| is_space(b)) {
                continue;
            }

            // 1) Exactly two spaces before `//`: in place of the blanks that
            //    stand between it and the token before, whose own last byte
            //    may be a blank (the character `$ `).
            edits.push(TextEdit {
                start_byte: blanks_before(bytes, comment),
                end_byte: at,
                replacement: "  ".to_string(),
            });

            // 2) At least one space after `//` if there's comment text.
            let after = at + 2;
            match bytes.get(after) {
                None | Some(b' ') => {}
                Some(&b) if is_newline(b) => {}
                // normalize tab to a single space
                Some(b'\t') => edits.push(TextEdit {
                    start_byte: after,
                    end_byte: after + 1,
                    replacement: " ".to_string(),
                }),
                Some(_) => edits.push(TextEdit {
                    start_byte: after,
                    end_byte: after,
                    replacement: " ".to_string(),
                }),
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
            &grammar::language(),
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

    #[test]
    fn test_the_tab_or_blank_of_a_character_before_a_comment_is_kept() {
        assert_eq!(format("x = $\t  // c"), "x = $\t  // c");
        assert_eq!(format("x = $\t// c"), "x = $\t  // c");
        assert_eq!(format("x = $  // c"), "x = $   // c");
    }
}
