// src/rules/pipe_body.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
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

pub struct PipeBodySpacing;

impl Rule for PipeBodySpacing {
    fn name(&self) -> &'static str {
        "pipe_body_spacing"
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
            let b = bytes[i];

            // inside comments/strings
            if in_line_comment {
                if b == b'\n' {
                    in_line_comment = false;
                }
                i += 1;
                continue;
            }

            if in_block_comment {
                if b == b'*' && i + 1 < len && bytes[i + 1] == b'/' {
                    in_block_comment = false;
                    i += 2;
                } else {
                    i += 1;
                }
                continue;
            }

            if in_single_str {
                if b == b'\'' && !is_escaped(bytes, i) {
                    in_single_str = false;
                }
                i += 1;
                continue;
            }

            if in_double_str {
                if b == b'"' && !is_escaped(bytes, i) {
                    in_double_str = false;
                }
                i += 1;
                continue;
            }

            // entering comments/strings
            if b == b'/' && i + 1 < len {
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

            if b == b'\'' {
                in_single_str = true;
                i += 1;
                continue;
            }

            if b == b'"' {
                in_double_str = true;
                i += 1;
                continue;
            }

            // actual rule: find `{ ... |args| body...` on a single line
            if b == b'{' {
                let brace_idx = i;

                // first pipe on the same line, only whitespace between { and |
                let mut j = brace_idx + 1;
                let mut left_pipe: Option<usize> = None;

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

                // second pipe on same line = closing pipe for block head
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

                // normalize spaces after the closing pipe
                let mut after = rp + 1;
                while after < len && is_space(bytes[after]) && !is_newline(bytes[after]) {
                    after += 1;
                }
                let has_ws = after > rp + 1;

                if after == len || is_newline(bytes[after]) {
                    // body starts on next line or EOF: no trailing spaces wanted
                    if has_ws {
                        edits.push(TextEdit {
                            start_byte: rp + 1,
                            end_byte: after,
                            replacement: String::new(),
                        });
                    }
                } else {
                    // body code is on same line: want exactly one space
                    if has_ws {
                        edits.push(TextEdit {
                            start_byte: rp + 1,
                            end_byte: after,
                            replacement: " ".to_string(),
                        });
                    } else {
                        edits.push(TextEdit {
                            start_byte: rp + 1,
                            end_byte: rp + 1,
                            replacement: " ".to_string(),
                        });
                    }
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
