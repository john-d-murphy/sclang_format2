use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

const fn is_space(byte: u8) -> bool {
    byte == b' ' || byte == b'\t'
}

const fn is_ident_start(byte: u8) -> bool {
    byte.is_ascii_lowercase() || byte.is_ascii_uppercase() || byte == b'_' || byte == b'\\'
}

const fn is_newline(byte: u8) -> bool {
    byte == b'\n' || byte == b'\r'
}

pub struct DotChainLayout;

impl Rule for DotChainLayout {
    fn name(&self) -> &'static str {
        "dot_chain_layout"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let len = bytes.len();
        let mut edits = Vec::new();

        // very simple comment/string tracking
        let mut in_line_comment = false;
        let mut in_block_comment = false;
        let mut in_single_str = false;
        let mut in_double_str = false;

        let mut i = 0usize;
        while i < len {
            let byte = bytes[i];

            // handle being inside comment/string
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
                if byte == b'\'' {
                    in_single_str = false;
                }
                i += 1;
                continue;
            }
            if in_double_str {
                if byte == b'"' {
                    in_double_str = false;
                }
                i += 1;
                continue;
            }

            // entering comment / string
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

            // main dot logic
            if byte == b'.' {
                let dot_idx = i;

                // don't touch decimal numbers like 1.5
                if dot_idx > 0 && bytes[dot_idx - 1].is_ascii_digit() {
                    i += 1;
                    continue;
                }

                // Check if dot is already at line start (after indent).
                // If so, it's already in good style—skip it.
                {
                    let mut check_idx = dot_idx;
                    while check_idx > 0 && is_space(bytes[check_idx - 1]) {
                        check_idx -= 1;
                    }
                    if check_idx == 0
                        || bytes[check_idx - 1] == b'\n'
                        || bytes[check_idx - 1] == b'\r'
                    {
                        // dot is at start of line (after indent), already good
                        i += 1;
                        continue;
                    }
                }

                // look ahead: dots we care about are ". [spaces]* <newline>"
                let mut j = dot_idx + 1;
                while j < len && is_space(bytes[j]) {
                    j += 1;
                }

                if j < len && is_newline(bytes[j]) {
                    // we have ". [ws]* <newline>"
                    let mut line_break_end = j + 1;
                    // handle CRLF
                    if bytes[j] == b'\r' && line_break_end < len && bytes[line_break_end] == b'\n' {
                        line_break_end += 1;
                    }

                    // find first non-WS on next line
                    let mut k = line_break_end;
                    while k < len && is_space(bytes[k]) {
                        k += 1;
                    }

                    if k < len {
                        let c = bytes[k];

                        // if the next line already starts with '.', it's already in good style
                        if c == b'.' {
                            i += 1;
                            continue;
                        }

                        // only move the dot if next token looks like an identifier/symbol
                        if is_ident_start(c) {
                            // 1) remove '.' and any spaces after it up to the newline
                            edits.push(TextEdit {
                                start_byte: dot_idx,
                                end_byte: j,
                                replacement: String::new(),
                            });

                            // 2) insert '.' before the identifier on the next line
                            edits.push(TextEdit {
                                start_byte: k,
                                end_byte: k,
                                replacement: ".".to_string(),
                            });

                            // we've handled this pair of lines; skip past the insertion
                            i = k + 1;
                            continue;
                        }
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
