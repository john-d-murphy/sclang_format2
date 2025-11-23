// src/rules/call_index_paren.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

const fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
}

const fn is_ident_char(b: u8) -> bool {
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

fn is_keyword(bytes: &[u8], start: usize, end: usize) -> bool {
    let word = &bytes[start..end];
    word == b"if" || word == b"while" || word == b"for" || word == b"switch" || word == b"case"
}

fn fix_before_delim(bytes: &[u8], delim: usize, edits: &mut Vec<TextEdit>) {
    if delim == 0 {
        return;
    }

    // find start of whitespace run before the delimiter
    let mut ws_start = delim;
    while ws_start > 0 && is_space(bytes[ws_start - 1]) && !is_newline(bytes[ws_start - 1]) {
        ws_start -= 1;
    }

    if ws_start == delim {
        // no spaces immediately before '(' / '[' on this line
        return;
    }

    let prev_index = match ws_start.checked_sub(1) {
        Some(i) => i,
        None => return,
    };

    let prev = bytes[prev_index];
    if is_newline(prev) {
        // '(' / '[' is at start of line (after indentation) – don't join
        return;
    }

    let mut call_like = false;

    if is_ident_char(prev) {
        // previous token is an identifier – check if it's a control keyword
        let mut word_start = prev_index;
        while word_start > 0 && is_ident_char(bytes[word_start - 1]) {
            word_start -= 1;
        }

        if is_keyword(bytes, word_start, prev_index + 1) {
            // keep `if (`, `while (`, etc.
            return;
        }

        call_like = true;
    } else if prev == b')' || prev == b']' || prev == b'}' {
        // e.g. foo().bar( ... ), array[0]( ... )
        call_like = true;
    }

    if !call_like {
        // e.g. '* (', '&& (', '+ (', etc. – leave spacing alone
        return;
    }

    // Now we know it's a call/index, so remove the spaces.
    edits.push(TextEdit {
        start_byte: ws_start,
        end_byte: delim,
        replacement: String::new(),
    });
}

pub struct CallIndexParenSpacing;

impl Rule for CallIndexParenSpacing {
    fn name(&self) -> &'static str {
        "call_index_paren_spacing"
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

            // actual rule: '(' and '[' for calls/indexing
            if b == b'(' || b == b'[' {
                fix_before_delim(bytes, i, &mut edits);
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
