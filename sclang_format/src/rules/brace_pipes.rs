use anyhow::Result;
use tree_sitter::{Node, Query, QueryCursor, StreamingIterator};

use crate::engine::{Ctx, TextEdit};

pub struct BraceAndPipesSingleLine;

impl BraceAndPipesSingleLine {
    fn same_line(src: &[u8], a: usize, b: usize) -> bool {
        !src[a..b].contains(&b'\n')
    }

    #[inline]
    fn in_comment_or_string(root: Node, byte: usize) -> bool {
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
}

impl crate::rules::Rule for BraceAndPipesSingleLine {
    fn name(&self) -> &'static str {
        "brace_pipe_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let src = bytes.as_slice();
        let root = cx.tree.root_node();
        let lang = cx.tree.language();

        let mut edits = Vec::<TextEdit>::new();

        // function_block captures the whole `{ ... }`
        let q = Query::new(&lang, r"(function_block) @blk")?;
        let mut cur = QueryCursor::new();
        let mut caps = cur.captures(&q, root, src);

        while let Some((m, idx)) = caps.next() {
            let blk = m.captures[*idx].node;
            let range = blk.byte_range();
            let open = range.start;
            let close = range.end - 1; // assuming '}' is last byte of the block

            if src.get(open) != Some(&b'{') || src.get(close) != Some(&b'}') {
                continue;
            }
            if !Self::same_line(src, open, close) {
                continue;
            }
            if Self::in_comment_or_string(root, open) {
                continue;
            }

            // After '{' -> exactly one space (unless already before '|', both fine: we want "{ |")
            let mut after_l = open + 1;
            while after_l < src.len() && src[after_l].is_ascii_whitespace() && src[after_l] != b'\n'
            {
                after_l += 1;
            }
            if after_l == open + 1 {
                edits.push(TextEdit {
                    start_byte: after_l,
                    end_byte: after_l,
                    replacement: " ".into(),
                });
            } else if after_l > open + 2 {
                edits.push(TextEdit {
                    start_byte: open + 1,
                    end_byte: after_l,
                    replacement: " ".into(),
                });
            }

            // Before '}' -> exactly one space (unless previous is '{', then "{ }" still okay)
            let mut before_r = close;
            while before_r > 0
                && src[before_r - 1].is_ascii_whitespace()
                && src[before_r - 1] != b'\n'
            {
                before_r -= 1;
            }
            if before_r == close {
                edits.push(TextEdit {
                    start_byte: before_r,
                    end_byte: before_r,
                    replacement: " ".into(),
                });
            } else if close - before_r != 1 {
                edits.push(TextEdit {
                    start_byte: before_r,
                    end_byte: close,
                    replacement: " ".into(),
                });
            }

            // Pipes: ensure "{ |" and "| }" if a parameter_list is present
            let p = blk.child_by_field_name("parameters");
            if let Some(params) = p {
                // params are enclosed in '|' ... '|'
                let pr = params.byte_range();
                // left pipe at pr.start - 1, right pipe at pr.end
                if pr.start > 0 && src.get(pr.start - 1) == Some(&b'|') {
                    // ensure a space between '{' and left pipe: already handled by the '{' rule ("{ ")
                    // ensure space **after** left pipe
                    let lp = pr.start - 1;
                    let mut after_lp = lp + 1;
                    while after_lp < src.len()
                        && src[after_lp].is_ascii_whitespace()
                        && src[after_lp] != b'\n'
                    {
                        after_lp += 1;
                    }
                    if after_lp == lp + 1 {
                        edits.push(TextEdit {
                            start_byte: after_lp,
                            end_byte: after_lp,
                            replacement: " ".into(),
                        });
                    } else if after_lp > lp + 2 {
                        edits.push(TextEdit {
                            start_byte: lp + 1,
                            end_byte: after_lp,
                            replacement: " ".into(),
                        });
                    }
                }
                if src.get(pr.end) == Some(&b'|') {
                    // ensure space **before** right pipe
                    let rp = pr.end;
                    let mut before_rp = rp;
                    while before_rp > 0
                        && src[before_rp - 1].is_ascii_whitespace()
                        && src[before_rp - 1] != b'\n'
                    {
                        before_rp -= 1;
                    }
                    if rp - before_rp == 0 {
                        edits.push(TextEdit {
                            start_byte: rp,
                            end_byte: rp,
                            replacement: " ".into(),
                        });
                    } else if rp - before_rp != 1 {
                        edits.push(TextEdit {
                            start_byte: before_rp,
                            end_byte: rp,
                            replacement: " ".into(),
                        });
                    }
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
