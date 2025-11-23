// src/rules/pipe_heads.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

const fn is_space(byte: u8) -> bool {
    byte == b' ' || byte == b'\t'
}

const fn is_newline(byte: u8) -> bool {
    byte == b'\n' || byte == b'\r'
}

/// Check if the quote at `i` is escaped by an odd number of backslashes.
fn is_escaped(bytes: &[u8], i: usize) -> bool {
    let mut count = 0;
    let mut j = i;
    while j > 0 {
        j -= 1;
        if bytes[j] == b'\\' {
            count += 1;
        } else {
            break;
        }
    }
    count % 2 == 1
}

pub struct PipeHeadSpacing;

impl Rule for PipeHeadSpacing {
    fn name(&self) -> &'static str {
        "pipe_head_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes();
        let bytes: &[u8] = &src;
        let len = bytes.len();

        let mut edits = Vec::new();

        let mut in_line_comment = false;
        let mut in_block_comment = false;
        let mut in_single_str = false;
        let mut in_double_str = false;

        let mut i = 0usize;
        while i < len {
            let byte = bytes[i];

            // inside comments/strings
            if in_line_comment {
                if byte == b'\n' {
                    in_line_comment = false;
                }
                i += 1;
                continue;
            }

            if in_block_comment {
                if byte == b'*' && i + 1 < len && bytes[i + 1] == b'/' {
                    in_block_comment = false;
                    i += 2;
                } else {
                    i += 1;
                }
                continue;
            }

            if in_single_str {
                if byte == b'\'' && !is_escaped(bytes, i) {
                    in_single_str = false;
                }
                i += 1;
                continue;
            }

            if in_double_str {
                if byte == b'"' && !is_escaped(bytes, i) {
                    in_double_str = false;
                }
                i += 1;
                continue;
            }

            // entering comments/strings
            if byte == b'/' && i + 1 < len {
                if bytes[i + 1] == b'/' {
                    in_line_comment = true;
                    i += 2;
                    continue;
                } else if bytes[i + 1] == b'*' {
                    in_block_comment = true;
                    i += 2;
                    continue;
                }
            }

            if byte == b'\'' {
                in_single_str = true;
                i += 1;
                continue;
            }

            if byte == b'"' {
                in_double_str = true;
                i += 1;
                continue;
            }

            // actual rule: block heads starting with `{` then optional ws then `|`
            if byte == b'{' {
                let brace_idx = i;

                let mut j = brace_idx + 1;
                let mut left_pipe: Option<usize> = None;

                // search to end of line for the first '|', but only allow ws before it
                while j < len {
                    let c = bytes[j];
                    if is_newline(c) {
                        break;
                    }
                    if c == b'|' {
                        left_pipe = Some(j);
                        break;
                    }
                    if !is_space(c) {
                        left_pipe = None;
                        break;
                    }
                    j += 1;
                }

                let Some(lp) = left_pipe else {
                    i += 1;
                    continue;
                };

                // now find closing pipe on the same line
                let mut k = lp + 1;
                let mut right_pipe: Option<usize> = None;
                while k < len {
                    let c = bytes[k];
                    if is_newline(c) {
                        break;
                    }
                    if c == b'|' {
                        right_pipe = Some(k);
                        break;
                    }
                    k += 1;
                }

                let Some(rp) = right_pipe else {
                    i += 1;
                    continue;
                };

                // 1) ensure exactly one space between '{' and first '|'
                let l = brace_idx + 1;
                let r = lp;
                if l == r {
                    // `{|` -> `{ |`
                    edits.push(TextEdit {
                        start_byte: l,
                        end_byte: l,
                        replacement: " ".to_string(),
                    });
                } else {
                    // `{  |` or `{ \t |` -> `{ |`
                    edits.push(TextEdit {
                        start_byte: l,
                        end_byte: r,
                        replacement: " ".to_string(),
                    });
                }

                // 2) remove spaces immediately *after* left pipe: `| a` -> `|a`
                let mut inner_start = lp + 1;
                while inner_start < len
                    && is_space(bytes[inner_start])
                    && !is_newline(bytes[inner_start])
                {
                    inner_start += 1;
                }
                if inner_start != lp + 1 {
                    edits.push(TextEdit {
                        start_byte: lp + 1,
                        end_byte: inner_start,
                        replacement: String::new(),
                    });
                }

                // 3) remove spaces immediately *before* right pipe: `a |` -> `a|`
                let mut inner_end = rp;
                while inner_end > lp + 1
                    && is_space(bytes[inner_end - 1])
                    && !is_newline(bytes[inner_end - 1])
                {
                    inner_end -= 1;
                }
                if inner_end != rp {
                    edits.push(TextEdit {
                        start_byte: inner_end,
                        end_byte: rp,
                        replacement: String::new(),
                    });
                }
            }

            i += 1;
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }

        Ok(n)
    }
}
