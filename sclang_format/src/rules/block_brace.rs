// src/rules/block_brace.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

const fn is_newline(b: u8) -> bool {
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

fn fix_before_brace(bytes: &[u8], brace: usize, edits: &mut Vec<TextEdit>) {
    if brace == 0 {
        return;
    }

    // find start of whitespace run before '{'
    let mut ws_start = brace;
    while ws_start > 0 && is_space(bytes[ws_start - 1]) && !is_newline(bytes[ws_start - 1]) {
        ws_start -= 1;
    }

    let prev_index = match ws_start.checked_sub(1) {
        Some(idx) => idx,
        None => return,
    };

    let prev = bytes[prev_index];
    if is_newline(prev) {
        // brace starts at beginning of line (after indentation); leave it
        return;
    }

    // we want exactly one space between prev token and '{'
    if brace - ws_start == 1 && bytes[ws_start] == b' ' {
        // already exactly one space
        return;
    }

    edits.push(TextEdit {
        start_byte: ws_start,
        end_byte: brace,
        replacement: " ".to_string(),
    });
}

pub struct BlockBraceSpacing;

impl Rule for BlockBraceSpacing {
    fn name(&self) -> &'static str {
        "block_brace_spacing"
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

            // actual rule: '{' after some token on the same line
            if b == b'{' {
                fix_before_brace(bytes, i, &mut edits);
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
