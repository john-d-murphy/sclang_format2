use crate::engine::{Ctx, TextEdit};
use anyhow::Result;

pub struct TrimTrailingWhitespaceAndEofNewline;

impl crate::rules::Rule for TrimTrailingWhitespaceAndEofNewline {
    fn name(&self) -> &'static str {
        "trailing_whitespace"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let b = bytes.as_slice();

        let mut edits = Vec::<TextEdit>::new();

        // Trim trailing spaces/tabs on each line
        let mut i = 0usize;
        while i < b.len() {
            let mut j = i;
            while j < b.len() && b[j] != b'\n' {
                j += 1;
            } // [i, j) is a line without '\n'
            let mut k = j;
            while k > i && (b[k - 1] == b' ' || b[k - 1] == b'\t') {
                k -= 1;
            }
            if k < j {
                edits.push(TextEdit {
                    start_byte: k,
                    end_byte: j,
                    replacement: String::new(),
                });
            }
            if j == b.len() {
                break;
            }
            i = j + 1;
        }

        // Ensure exactly one trailing newline
        if b.is_empty() {
            edits.push(TextEdit {
                start_byte: 0,
                end_byte: 0,
                replacement: "\n".into(),
            });
        } else if b.ends_with(b"\n\n") {
            // collapse to single
            let mut pos = b.len() - 1;
            while pos > 0 && b[pos - 1] == b'\n' {
                pos -= 1;
            }
            edits.push(TextEdit {
                start_byte: pos,
                end_byte: b.len(),
                replacement: "\n".into(),
            });
        } else if !b.ends_with(b"\n") {
            edits.push(TextEdit {
                start_byte: b.len(),
                end_byte: b.len(),
                replacement: "\n".into(),
            });
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
