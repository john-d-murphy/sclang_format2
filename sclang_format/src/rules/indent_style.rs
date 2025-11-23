use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

fn is_ws(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

pub struct IndentStyleRule;

impl Rule for IndentStyleRule {
    fn name(&self) -> &'static str {
        "indent_style"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let len = bytes.len();

        let mut edits = Vec::new();
        let mut i = 0usize;

        while i < len {
            let line_start = i;

            // find end of line
            while i < len && bytes[i] != b'\n' {
                i += 1;
            }
            let line_end = i; // points at '\n' or len

            // find first non-WS char
            let mut j = line_start;
            while j < line_end && is_ws(bytes[j]) {
                j += 1;
            }

            // if line is all whitespace or empty, we can normalize to empty
            if j == line_end {
                if line_end > line_start {
                    edits.push(TextEdit {
                        start_byte: line_start,
                        end_byte: line_end,
                        replacement: String::new(),
                    });
                }
            } else {
                // compute "indent level" from current leading WS in units of columns
                // we don't try to deduce logical nesting; we just convert style.
                let mut cols = 0usize;
                for &b in &bytes[line_start..j] {
                    match b {
                        b'\t' => {
                            cols += match cx.indent_style {
                                // tabs-as-indent: treat one tab as one "unit"
                                crate::engine::IndentStyle::Tabs => 1,
                                crate::engine::IndentStyle::Spaces { width } => width,
                            }
                        }
                        b' ' => cols += 1,
                        _ => {}
                    }
                }

                // decide how many "units" we want (cols / width)
                let (units, extra_spaces) = match cx.indent_style {
                    crate::engine::IndentStyle::Tabs => (cols, 0),
                    crate::engine::IndentStyle::Spaces { width } => {
                        if width == 0 {
                            (0, cols)
                        } else {
                            (cols / width, cols % width)
                        }
                    }
                };

                let mut new_indent = String::new();
                match cx.indent_style {
                    crate::engine::IndentStyle::Tabs => {
                        new_indent.push_str(&"\t".repeat(units));
                    }
                    crate::engine::IndentStyle::Spaces { width } => {
                        new_indent.push_str(&" ".repeat(units * width + extra_spaces));
                    }
                }

                if new_indent.as_bytes() != &bytes[line_start..j] {
                    edits.push(TextEdit {
                        start_byte: line_start,
                        end_byte: j,
                        replacement: new_indent,
                    });
                }
            }

            // skip newline
            if i < len && bytes[i] == b'\n' {
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
