// src/rules/colons.rs

use anyhow::Result;
use tree_sitter::Node;

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;

pub struct AddSpacesAroundColons;

impl AddSpacesAroundColons {
    #[inline]
    fn in_comment_or_string(root: Node, byte: usize) -> bool {
        let mut cur = root.descendant_for_byte_range(byte, byte + 1);
        while let Some(n) = cur {
            match n.kind() {
                // conservative skip list; adjust if your grammar uses different names
                "comment" | "block_comment" | "line_comment" | "string" => return true,
                _ => {}
            }
            cur = n.parent();
        }
        false
    }

    #[inline]
    fn fix_one(bytes: &[u8], colon: usize, edits: &mut Vec<TextEdit>) {
        let len = bytes.len();

        // Don't touch weird double-colon things just in case
        if bytes.get(colon + 1) == Some(&b':') {
            return;
        }

        // ----- left side: NO spaces before ':' -----
        let mut l = colon;
        while l > 0 && bytes[l - 1].is_ascii_whitespace() && bytes[l - 1] != b'\n' {
            l -= 1;
        }
        if l < colon {
            // strip all spaces before colon
            edits.push(TextEdit {
                start_byte: l,
                end_byte: colon,
                replacement: String::new(),
            });
        }

        // ----- right side: at most one space after ':' -----
        let mut r = colon + 1;
        while r < len && bytes[r].is_ascii_whitespace() && bytes[r] != b'\n' {
            r += 1;
        }

        let has_ws_after = r > colon + 1;
        let next_is_newline = r < len && bytes[r] == b'\n';

        match (has_ws_after, next_is_newline) {
            // No whitespace after ':' and next is non-newline, insert one space.
            (false, false) if r < len => {
                edits.push(TextEdit {
                    start_byte: r,
                    end_byte: r,
                    replacement: " ".to_string(),
                });
            }
            // There was whitespace after ':', and next is non-newline:
            // compress run to a single space.
            (true, false) if r < len => {
                edits.push(TextEdit {
                    start_byte: colon + 1,
                    end_byte: r,
                    replacement: " ".to_string(),
                });
            }
            // If next is newline or EOF, we want *no* spaces after colon.
            (true, true) | (true, false) if r == len => {
                edits.push(TextEdit {
                    start_byte: colon + 1,
                    end_byte: r,
                    replacement: String::new(),
                });
            }
            // (false, true) or (false, false with r == len):
            // no spaces and nothing non-newline after -> nothing to do.
            _ => {}
        }
    }
}

impl Rule for AddSpacesAroundColons {
    fn name(&self) -> &'static str {
        "spaces_around_colons"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src = cx.bytes();
        let bytes: &[u8] = &src;

        let mut edits: Vec<TextEdit> = Vec::new();

        for (i, &b) in bytes.iter().enumerate() {
            if b != b':' {
                continue;
            }

            if Self::in_comment_or_string(root, i) {
                continue;
            }

            Self::fix_one(bytes, i, &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
