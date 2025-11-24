// src/rules/ast_indent.rs

use crate::engine::{Ctx, IndentStyle, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

/// Simple comment/string tracker so we ignore braces inside them.
#[derive(Clone, Copy, Debug)]
struct CommentState {
    in_line: bool,
    in_block: bool,
    in_single: bool,
    in_double: bool,
    prev: u8,
}

impl CommentState {
    const fn new() -> Self {
        CommentState {
            in_line: false,
            in_block: false,
            in_single: false,
            in_double: false,
            prev: 0,
        }
    }

    #[inline]
    const fn in_comment_or_string(&self) -> bool {
        self.in_line || self.in_block || self.in_single || self.in_double
    }

    #[inline]
    fn step(&mut self, b: u8) {
        // already inside something
        if self.in_line {
            if b == b'\n' {
                self.in_line = false;
            }
            self.prev = b;
            return;
        }

        if self.in_block {
            if self.prev == b'*' && b == b'/' {
                self.in_block = false;
            }
            self.prev = b;
            return;
        }

        if self.in_single {
            if b == b'\'' && self.prev != b'\\' {
                self.in_single = false;
            }
            self.prev = b;
            return;
        }

        if self.in_double {
            if b == b'"' && self.prev != b'\\' {
                self.in_double = false;
            }
            self.prev = b;
            return;
        }

        // not currently inside anything → maybe *enter* a comment/string
        if self.prev == b'/' && b == b'/' {
            self.in_line = true;
        } else if self.prev == b'/' && b == b'*' {
            self.in_block = true;
        } else if b == b'\'' {
            self.in_single = true;
        } else if b == b'"' {
            self.in_double = true;
        }

        self.prev = b;
    }
}

pub struct IndentByAstLevel;

impl IndentByAstLevel {
    #[inline]
    fn make_indent(style: IndentStyle, level: usize) -> String {
        match style {
            IndentStyle::Tabs => "\t".repeat(level),
            IndentStyle::Spaces { width } => " ".repeat(level * width),
        }
    }
}

impl Rule for IndentByAstLevel {
    fn name(&self) -> &'static str {
        "indent_by_ast_level"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes(); // Vec<u8>
        let bytes: &[u8] = src.as_slice();
        let len = bytes.len();

        let mut edits: Vec<TextEdit> = Vec::new();
        let mut cs = CommentState::new();

        // "Depth" here is brace depth: how many `{` blocks we are inside
        // *at the start of the current line*.
        let mut depth: isize = 0;

        let mut i: usize = 0;
        while i < len {
            let line_start = i;

            // Find end of line (exclusive).
            let mut line_end = i;
            while line_end < len && bytes[line_end] != b'\n' {
                line_end += 1;
            }

            // Find first non-space/tab on the line.
            let mut first_non_ws = line_start;
            while first_non_ws < line_end {
                let b = bytes[first_non_ws];
                if b == b' ' || b == b'\t' {
                    // whitespace doesn't affect comment/string state
                    first_non_ws += 1;
                } else {
                    break;
                }
            }

            // Blank / whitespace-only line: leave indentation alone, just
            // advance over newline and keep comment state in sync.
            if first_non_ws == line_end {
                if line_end < len {
                    cs.step(b'\n');
                    i = line_end + 1;
                } else {
                    i = len;
                }
                continue;
            }

            // We now have some code on this line. We want "closing brace at
            // start of line" lines to be indented one level *less* than the
            // current depth (classic K&R behavior).
            let first = bytes[first_non_ws];

            // Feed this byte into the comment/string state so we know whether
            // it's actually part of code or inside a comment.
            cs.step(first);

            // Effective depth for *this* line.
            let mut effective_depth = depth;
            let scan_start = first_non_ws + 1;

            if !cs.in_comment_or_string() && first == b'}' {
                // Line starts with a real closing brace: dedent this line.
                if depth > 0 {
                    depth -= 1;
                }
                if depth < 0 {
                    depth = 0;
                }
                effective_depth = depth;
                // We already processed this '}', so subsequent scanning starts
                // after it.
            } else if !cs.in_comment_or_string() && first == b'{' {
                // Opening brace as first token on line: indent stays at the
                // old depth for this line, but subsequent lines will see
                // depth+1. So we count it *after* computing indentation.
                effective_depth = if depth < 0 { 0 } else { depth };
                depth += 1;
            } else {
                // Normal code, or comment/string start: no special treatment.
                effective_depth = if depth < 0 { 0 } else { depth };
            }

            // Compute the desired indentation string.
            let new_indent = Self::make_indent(cx.indent_style, effective_depth as usize);

            // Existing indentation slice (spaces/tabs only).
            let existing_indent = &bytes[line_start..first_non_ws];
            if existing_indent != new_indent.as_bytes() {
                edits.push(TextEdit {
                    start_byte: line_start,
                    end_byte: first_non_ws,
                    replacement: new_indent,
                });
            }

            // Now scan the *rest* of the line for additional braces, updating
            // depth for subsequent lines. We ignore braces inside comments
            // and strings.
            let mut k = scan_start;
            while k < line_end {
                let b = bytes[k];
                cs.step(b);
                if !cs.in_comment_or_string() {
                    if b == b'{' {
                        depth += 1;
                    } else if b == b'}' {
                        if depth > 0 {
                            depth -= 1;
                        }
                    }
                }
                k += 1;
            }

            // Finally feed the newline into the comment state and advance.
            if line_end < len {
                cs.step(b'\n');
                i = line_end + 1;
            } else {
                i = len;
            }
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

