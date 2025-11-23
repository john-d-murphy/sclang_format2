use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

/// AST-based “are we in a string/comment?”
fn in_comment_or_string(root: &Node, byte: usize) -> bool {
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

pub struct NoFinalSemicolon;

impl Rule for NoFinalSemicolon {
    fn name(&self) -> &'static str {
        "no_final_semicolon_before_brace"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let buf: &[u8] = &bytes;
        let root = cx.tree.root_node();
        let len = buf.len();

        let mut edits: Vec<TextEdit> = Vec::new();

        for i in 0..len {
            if buf[i] != b'}' {
                continue;
            }

            // Don't touch braces inside strings/comments.
            if in_comment_or_string(&root, i) {
                continue;
            }

            let mut j = i;
            // Walk backwards over whitespace to find the last “real” char.
            while j > 0 {
                j -= 1;
                let c = buf[j];
                if c == b' ' || c == b'\t' || c == b'\r' || c == b'\n' {
                    continue;
                }

                // If that char is a ';' and not in a comment/string, drop it.
                if c == b';' && !in_comment_or_string(&root, j) {
                    edits.push(TextEdit {
                        start_byte: j,
                        end_byte: j + 1,
                        replacement: String::new(),
                    });
                }

                break;
            }
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
