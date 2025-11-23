// src/rules/inline_comment_spacing.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
}

// Very simple "are we inside a string up to idx?" check, just to
// avoid touching `//` inside `"..."` or `'...'`.
fn is_string_context(bytes: &[u8], idx: usize) -> bool {
    let mut in_single = false;
    let mut in_double = false;
    let mut i = 0usize;

    while i < idx && i < bytes.len() {
        let b = bytes[i];

        if in_single {
            if b == b'\\' && i + 1 < idx {
                i += 2;
                continue;
            } else if b == b'\'' {
                in_single = false;
            }
        } else if in_double {
            if b == b'\\' && i + 1 < idx {
                i += 2;
                continue;
            } else if b == b'"' {
                in_double = false;
            }
        } else {
            if b == b'\'' {
                in_single = true;
            } else if b == b'"' {
                in_double = true;
            }
        }

        i += 1;
    }

    in_single || in_double
}

pub struct InlineCommentSpacing;

impl Rule for InlineCommentSpacing {
    fn name(&self) -> &'static str {
        "inline_comment_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes();
        let bytes: &[u8] = &src;
        let len = bytes.len();
        let mut edits: Vec<TextEdit> = Vec::new();

        let mut i = 0usize;
        while i + 1 < len {
            if bytes[i] == b'/' && bytes[i + 1] == b'/' {
                // Skip `//` inside strings.
                if is_string_context(bytes, i) {
                    i += 2;
                    continue;
                }

                // Find start of line.
                let mut line_start = i;
                while line_start > 0 && bytes[line_start - 1] != b'\n' {
                    line_start -= 1;
                }

                // Check if there's any non-space before the comment → inline.
                let mut j = line_start;
                let mut has_code_before = false;
                while j < i {
                    if !is_space(bytes[j]) {
                        has_code_before = true;
                        break;
                    }
                    j += 1;
                }

                if !has_code_before {
                    // Full-line `// foo` – we don't touch.
                    i += 2;
                    continue;
                }

                // 1) Exactly two spaces before `//`.
                let mut ws_start = i;
                while ws_start > line_start && is_space(bytes[ws_start - 1]) {
                    ws_start -= 1;
                }
                edits.push(TextEdit {
                    start_byte: ws_start,
                    end_byte: i,
                    replacement: "  ".to_string(),
                });

                // 2) At least one space after `//` if there's comment text.
                let after = i + 2;
                if after < len && !is_newline(bytes[after]) {
                    if bytes[after] == b' ' {
                        // fine
                    } else if bytes[after] == b'\t' {
                        // normalize tab to a single space
                        edits.push(TextEdit {
                            start_byte: after,
                            end_byte: after + 1,
                            replacement: " ".to_string(),
                        });
                    } else {
                        edits.push(TextEdit {
                            start_byte: after,
                            end_byte: after,
                            replacement: " ".to_string(),
                        });
                    }
                }

                i += 2;
            } else {
                i += 1;
            }
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
