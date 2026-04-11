use crate::engine::{Ctx, TextEdit};
use crate::engine::ast::descendants_of_kind;
use crate::rules::Rule;
use anyhow::Result;

const fn is_space_or_tab(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

/// Ensure that multi-line array literals (`[ ... ]`) have exactly
/// one element per line, but *only* for real collection literals,
/// not for indexing or other uses of `[`.
///
/// This uses the AST to:
///   * Only consider `[` tokens that belong to a `collection` node.
///   * Explicitly skip `indexed_collection` / `index_subrange` uses.
pub struct MultiLineArrayElementsPerLine;

impl Rule for MultiLineArrayElementsPerLine {
    fn name(&self) -> &'static str {
        "multiline_array_elements_per_line"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let buf: &[u8] = &bytes;
        let len = buf.len();
        let root = cx.tree.root_node();

        let mut edits: Vec<TextEdit> = Vec::new();

        // Walk all `[` tokens in the tree, but restrict ourselves to those
        // that live under a `collection` node (and not under index nodes).
        for bracket in descendants_of_kind(root, "[") {
            let open = bracket.start_byte();
            if open >= len {
                continue;
            }

            // Check ancestry: we want a `collection` ancestor, and we want
            // to skip things that are clearly indexing.
            let mut cur = bracket.parent();
            let mut is_collection_array = false;

            while let Some(node) = cur {
                match node.kind() {
                    // Treat anything inside an index as *not* a literal.
                    "index_subrange" | "indexed_collection" => {
                        is_collection_array = false;
                        break;
                    }
                    "collection" => {
                        is_collection_array = true;
                        break;
                    }
                    _ => {
                        cur = node.parent();
                    }
                }
            }

            if !is_collection_array {
                continue;
            }

            // Find the matching closing ']'. At this point we know this
            // '[' really is the start of a collection literal.
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

            let close = if let Some(c) = close_opt {
                c
            } else {
                continue;
            };

            // Only bother with arrays that are already multi-line.
            let mut has_nl = false;
            for k in (open + 1)..close {
                if buf[k] == b'\n' {
                    has_nl = true;
                    break;
                }
            }
            if !has_nl {
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
                        let mut k = idx + 1;

                        // Skip spaces/tabs (but *not* newlines).
                        while k < seg.len() && is_space_or_tab(seg[k]) {
                            k += 1;
                        }
                        if k >= seg.len() {
                            continue;
                        }

                        // If the next thing is a newline, we already have an
                        // element-per-line layout.
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

                        // Otherwise, we have another element starting on the
                        // same line. Insert a newline + indent before it.
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
                            format!("\n{indent}")
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
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

