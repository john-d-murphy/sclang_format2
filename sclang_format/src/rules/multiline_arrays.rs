use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

fn is_space_or_tab(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

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

pub struct MultiLineArrayElementsPerLine;

impl Rule for MultiLineArrayElementsPerLine {
    fn name(&self) -> &'static str {
        "multiline_array_elements_per_line"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let buf: &[u8] = &bytes;
        let root = cx.tree.root_node();
        let len = buf.len();

        let mut edits: Vec<TextEdit> = Vec::new();
        let mut i = 0;

        while i < len {
            if buf[i] == b'[' {
                // skip arrays that are inside comments/strings
                if in_comment_or_string(&root, i) {
                    i += 1;
                    continue;
                }

                let open = i;
                let mut depth = 1i32;
                let mut j = open + 1;
                let mut close_opt = None;

                while j < len {
                    match buf[j] {
                        b'[' => depth += 1,
                        b']' => {
                            depth -= 1;
                            if depth == 0 {
                                close_opt = Some(j);
                                break;
                            }
                        }
                        _ => {}
                    }
                    j += 1;
                }

                let close = match close_opt {
                    Some(c) => c,
                    None => {
                        i += 1;
                        continue;
                    }
                };

                // Only operate on *multi-line* arrays.
                let mut has_nl = false;
                for k in (open + 1)..close {
                    if buf[k] == b'\n' {
                        has_nl = true;
                        break;
                    }
                }
                if !has_nl {
                    i = close + 1;
                    continue;
                }

                let seg_lo = open + 1;
                let seg_hi = close;
                let seg = &buf[seg_lo..seg_hi];

                let mut paren = 0i32;
                let mut brace = 0i32;
                let mut bracket = 0i32;

                for (idx, &b) in seg.iter().enumerate() {
                    match b {
                        b'(' => paren += 1,
                        b')' => paren -= 1,
                        b'{' => brace += 1,
                        b'}' => brace -= 1,
                        b'[' => bracket += 1,
                        b']' => bracket -= 1,
                        b',' if paren == 0 && brace == 0 && bracket == 0 => {
                            // We have a top-level comma inside the array.
                            let mut k = idx + 1;

                            // skip spaces/tabs (but *not* newlines)
                            while k < seg.len() && is_space_or_tab(seg[k]) {
                                k += 1;
                            }
                            if k >= seg.len() {
                                continue;
                            }

                            // If the next thing is newline, we already have
                            // an element-per-line layout.
                            if seg[k] == b'\n' {
                                continue;
                            }

                            // If the next token starts a comment, we treat it as
                            // “same element with trailing comment”, also fine.
                            if seg[k] == b'/' && k + 1 < seg.len() {
                                let c2 = seg[k + 1];
                                if c2 == b'/' || c2 == b'*' {
                                    continue;
                                }
                            }

                            // Otherwise, we have another element starting on the same line.
                            // Insert a newline + indent before that token.

                            let insert_global = seg_lo + k;

                            // Compute indent from start of this line.
                            let mut line_start = insert_global;
                            while line_start > 0 && buf[line_start - 1] != b'\n' {
                                line_start -= 1;
                            }
                            let mut indent_end = line_start;
                            while indent_end < insert_global && is_space_or_tab(buf[indent_end]) {
                                indent_end += 1;
                            }

                            let indent =
                                String::from_utf8_lossy(&buf[line_start..indent_end]).to_string();

                            let replacement = if indent.is_empty() {
                                "\n".to_string()
                            } else {
                                format!("\n{}", indent)
                            };

                            edits.push(TextEdit {
                                start_byte: insert_global,
                                end_byte: insert_global,
                                replacement,
                            });
                        }
                        _ => {}
                    }
                }

                i = close + 1;
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
