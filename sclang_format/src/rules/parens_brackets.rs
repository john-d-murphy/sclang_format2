// src/rules/parens_brackets.rs

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

pub struct ParenBracketSpacing;

impl Rule for ParenBracketSpacing {
    fn name(&self) -> &'static str {
        "paren_bracket_spacing"
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

            // actual rule: interior spacing of () and []
            match b {
                b'(' | b'[' => {
                    // remove spaces immediately after the opening delimiter, but
                    // don't cross a newline.
                    let mut j = i + 1;
                    if j < len && is_space(bytes[j]) {
                        while j < len && is_space(bytes[j]) && !is_newline(bytes[j]) {
                            j += 1;
                        }
                        if j > i + 1 {
                            edits.push(TextEdit {
                                start_byte: i + 1,
                                end_byte: j,
                                replacement: String::new(),
                            });
                        }
                    }
                }
                b')' | b']' => {
                    // remove spaces immediately before the closing delimiter,
                    // but don't cross a newline.
                    if i > 0 && is_space(bytes[i - 1]) {
                        let mut j = i;
                        while j > 0 && is_space(bytes[j - 1]) && !is_newline(bytes[j - 1]) {
                            j -= 1;
                        }
                        if j < i {
                            edits.push(TextEdit {
                                start_byte: j,
                                end_byte: i,
                                replacement: String::new(),
                            });
                        }
                    }
                }
                _ => {}
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
