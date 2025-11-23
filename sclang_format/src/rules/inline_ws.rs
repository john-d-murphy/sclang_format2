use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::*;

/// Simple whitespace predicates
fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

/// Returns true if the `=` at position `i` *looks* like an assignment,
/// not `==`, `!=`, `<=`, `>=`, etc.
fn is_assignment_equal(src: &[u8], i: usize) -> bool {
    // previous non-space char
    let mut j = i;
    let mut prev: Option<u8> = None;
    while j > 0 {
        j -= 1;
        if !is_space(src[j]) {
            prev = Some(src[j]);
            break;
        }
    }

    // next non-space char
    let mut k = i + 1;
    let mut next: Option<u8> = None;
    while k < src.len() {
        if !is_space(src[k]) {
            next = Some(src[k]);
            break;
        }
        k += 1;
    }

    if let Some(c) = prev
        && matches!(c, b'=' | b'!' | b'<' | b'>')
    {
        // likely part of ==, !=, <=, >=, =>, etc.
        return false;
    }
    if let Some(c) = next
        && c == b'='
    {
        // ==, ===, etc.
        return false;
    }

    true
}

/// Check if the quote at position `i` is escaped with an odd number of backslashes.
fn is_escaped(src: &[u8], i: usize) -> bool {
    let mut count = 0;
    let mut j = i;
    while j > 0 {
        j -= 1;
        if src[j] == b'\\' {
            count += 1;
        } else {
            break;
        }
    }
    count % 2 == 1
}

pub struct InlineWhitespaceFormat;

impl Rule for InlineWhitespaceFormat {
    fn name(&self) -> &'static str {
        "InlineWhitespaceFormat"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes(); // Vec<u8> from Rope

        let mut edits: Vec<TextEdit> = Vec::new();
        let len = src.len();

        let mut i = 0usize;

        // Very small lexical state machine so we don't mangle strings/comments.
        let mut in_line_comment = false;
        let mut in_block_comment = false;
        let mut in_single_str = false;
        let mut in_double_str = false;

        while i < len {
            let b = src[i];

            // --- handle being *inside* comments/strings first ---

            if in_line_comment {
                if b == b'\n' {
                    in_line_comment = false;
                }
                i += 1;
                continue;
            }

            if in_block_comment {
                if b == b'*' && i + 1 < len && src[i + 1] == b'/' {
                    in_block_comment = false;
                    i += 2;
                } else {
                    i += 1;
                }
                continue;
            }

            if in_single_str {
                if b == b'\'' && !is_escaped(&src, i) {
                    in_single_str = false;
                }
                i += 1;
                continue;
            }

            if in_double_str {
                if b == b'"' && !is_escaped(&src, i) {
                    in_double_str = false;
                }
                i += 1;
                continue;
            }

            // --- we are in "code" now: detect starts of comments/strings ---

            if b == b'/' && i + 1 < len {
                if src[i + 1] == b'/' {
                    in_line_comment = true;
                    i += 2;
                    continue;
                } else if src[i + 1] == b'*' {
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

            // --- actual inline whitespace rule: normalize around assignment '=' ---

            if b == b'=' && is_assignment_equal(&src, i) {
                // Don't normalize spacing if we have K&R-style block attachment (= {)
                // Check if the next non-space char is a brace
                let mut is_kandr_attachment = false;
                {
                    let mut check_r = i + 1;
                    while check_r < len && is_space(src[check_r]) {
                        check_r += 1;
                    }
                    if check_r < len && src[check_r] == b'{' {
                        is_kandr_attachment = true;
                    }
                }

                if !is_kandr_attachment {
                    // left side: ensure exactly one space before '='
                    let mut p = i;
                    while p > 0 && is_space(src[p - 1]) {
                        p -= 1;
                    }
                    let lhs_ws_start = p;

                    if lhs_ws_start < i {
                        // replace existing left whitespace with a single space
                        edits.push(TextEdit {
                            start_byte: lhs_ws_start,
                            end_byte: i,
                            replacement: " ".into(),
                        });
                    } else {
                        // no whitespace before '=', insert a single space
                        edits.push(TextEdit {
                            start_byte: i,
                            end_byte: i,
                            replacement: " ".into(),
                        });
                    }

                    // right side: ensure exactly one space after '='
                    let mut q = i + 1;
                    while q < len && is_space(src[q]) {
                        q += 1;
                    }
                    let rhs_ws_end = q;

                    if i + 1 < rhs_ws_end {
                        // replace existing right whitespace with a single space
                        edits.push(TextEdit {
                            start_byte: i + 1,
                            end_byte: rhs_ws_end,
                            replacement: " ".into(),
                        });
                    } else {
                        // no whitespace after '=', insert a single space
                        edits.push(TextEdit {
                            start_byte: i + 1,
                            end_byte: i + 1,
                            replacement: " ".into(),
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
