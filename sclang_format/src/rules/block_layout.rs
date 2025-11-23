use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
}

fn is_line_comment(line: &[u8]) -> bool {
    // find first non-WS char
    let mut i = 0;
    while i < line.len() && is_space(line[i]) {
        i += 1;
    }
    if i + 1 < line.len() && line[i] == b'/' && line[i + 1] == b'/' {
        return true;
    }
    false
}

/// Only allow K&R brace attach on lines that look like "x =" or "if (...)"
/// and *do not* already contain a '{' or '}'.
fn line_can_take_brace(line: &[u8]) -> bool {
    if is_line_comment(line) {
        return false;
    }
    // Don't touch lines that already have a brace
    if line.iter().any(|&b| b == b'{' || b == b'}') {
        return false;
    }

    // Ignore empty / all-WS lines
    let mut end = line.len();
    while end > 0 && is_space(line[end - 1]) {
        end -= 1;
    }
    if end == 0 {
        return false;
    }

    let last = line[end - 1];

    // Very conservative: only lines ending with these can take a block:
    // "x =", "if (...)", "foo]", "bar}"
    matches!(last, b'=' | b')' | b']' | b'}')
}

pub struct BlockLayoutKAndR;

impl Rule for BlockLayoutKAndR {
    fn name(&self) -> &'static str {
        "block_layout_kandr"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let len = bytes.len();
        let mut edits = Vec::new();

        // Collect line starts
        let mut line_starts = Vec::new();
        line_starts.push(0usize);
        for i in 0..len {
            if bytes[i] == b'\n' {
                if i + 1 < len {
                    line_starts.push(i + 1);
                }
            }
        }

        for w in line_starts.windows(2) {
            let start = w[0];
            let next_start = w[1];

            // current line slice [start, line_end)
            let mut line_end = next_start;
            if line_end > start && is_newline(bytes[line_end - 1]) {
                line_end -= 1;
            }
            let line = &bytes[start..line_end];

            // Skip comments / lines that can't take a brace
            if !line_can_take_brace(line) {
                continue;
            }

            // Next line slice [next_start, next_end)
            let mut next_end = len;
            for i in next_start..len {
                if bytes[i] == b'\n' {
                    next_end = i;
                    break;
                }
            }
            let next_line = &bytes[next_start..next_end];

            // If next line is a comment, skip
            if is_line_comment(next_line) {
                continue;
            }

            // Parse next line: must be only indent + '{' + optional spaces
            let mut j = 0usize;
            while j < next_line.len() && is_space(next_line[j]) {
                j += 1;
            }
            if j >= next_line.len() || next_line[j] != b'{' {
                continue; // doesn't start with '{'
            }
            j += 1;

            // Everything after '{' on that line must be spaces
            let mut k = j;
            while k < next_line.len() && is_space(next_line[k]) {
                k += 1;
            }

            if k != next_line.len() {
                // there's other stuff on the line (e.g. "{ foo"), don't touch
                continue;
            }

            // At this point we know we have:
            // [line]\n[WS]{[WS]*\n
            // Remove from the newline after current line up through the end of the brace line.
            let newline_pos = line_end; // '\n' after current line
            let remove_start = newline_pos;
            let remove_end = next_end; // <- changed from next_start + j

            edits.push(TextEdit {
                start_byte: remove_start,
                end_byte: remove_end,
                replacement: " {".to_string(),
            });
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
