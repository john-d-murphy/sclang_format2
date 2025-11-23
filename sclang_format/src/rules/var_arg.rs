// src/rules/var_arg.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
}

fn is_ident_char(b: u8) -> bool {
    b.is_ascii_lowercase() || b.is_ascii_uppercase() || b.is_ascii_digit() || b == b'_'
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

fn is_keyword_start(bytes: &[u8], i: usize, kw: &[u8]) -> bool {
    let len = bytes.len();
    let klen = kw.len();
    if i + klen > len {
        return false;
    }
    if &bytes[i..i + klen] != kw {
        return false;
    }

    // preceding boundary: start-of-file or non-identifier
    if i > 0 {
        let prev = bytes[i - 1];
        if is_ident_char(prev) {
            return false;
        }
    }

    // following boundary: end-of-file or non-identifier
    if i + klen < len {
        let next = bytes[i + klen];
        if is_ident_char(next) {
            return false;
        }
    }

    true
}

/// Ensure exactly one ASCII space after a keyword (`var` or `arg`),
/// unless the next non-space is a newline/EOF.
fn fix_after_keyword(bytes: &[u8], start: usize, kw_len: usize, edits: &mut Vec<TextEdit>) {
    let len = bytes.len();
    let l = start + kw_len;
    if l >= len {
        return;
    }

    let mut r = l;
    while r < len && is_space(bytes[r]) && !is_newline(bytes[r]) {
        r += 1;
    }

    if r == l {
        // no spaces currently after keyword
        if r < len && !is_newline(bytes[r]) {
            edits.push(TextEdit {
                start_byte: l,
                end_byte: l,
                replacement: " ".to_string(),
            });
        }
    } else {
        // some spaces; compress to a single one
        if r - l != 1 {
            edits.push(TextEdit {
                start_byte: l,
                end_byte: r,
                replacement: " ".to_string(),
            });
        }
    }
}

pub struct VarAndArgSpacing;

impl Rule for VarAndArgSpacing {
    fn name(&self) -> &'static str {
        "var_and_arg_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes();
        let bytes: &[u8] = &src;
        let len = bytes.len();

        let mut edits = Vec::new();

        // tiny lexer just to skip comments/strings
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

            // actual rule: `var` / `arg` keywords
            if is_keyword_start(bytes, i, b"var") {
                fix_after_keyword(bytes, i, 3, &mut edits);
                i += 3;
                continue;
            }

            if is_keyword_start(bytes, i, b"arg") {
                fix_after_keyword(bytes, i, 3, &mut edits);
                i += 3;
                continue;
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
