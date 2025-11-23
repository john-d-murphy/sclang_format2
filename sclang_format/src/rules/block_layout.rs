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
    i + 1 < line.len() && line[i] == b'/' && line[i + 1] == b'/'
}

/// Only allow K&R brace attach on lines that look like "x =" or "if (...)"
/// and *do not* already contain a '{' or '}' or already have K&R-style attachment.
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

/// Return slice for a line starting at `start` up to but not including '\n',
/// and the index of that '\n' or `len` if none.
fn line_slice(bytes: &[u8], start: usize, len: usize) -> (usize, &[u8]) {
    let mut end = start;
    while end < len && bytes[end] != b'\n' {
        end += 1;
    }
    (end, &bytes[start..end])
}

fn leading_ws_len(line: &[u8]) -> usize {
    let mut i = 0;
    while i < line.len() && is_space(line[i]) {
        i += 1;
    }
    i
}

/// True if, ignoring leading/trailing spaces/tabs, `line` is exactly `token`.
fn is_exact_token(line: &[u8], token: &[u8]) -> bool {
    let mut start = 0;
    while start < line.len() && is_space(line[start]) {
        start += 1;
    }
    let mut end = line.len();
    while end > start && is_space(line[end - 1]) {
        end -= 1;
    }
    &line[start..end] == token
}

pub struct BlockLayoutKAndR;

impl BlockLayoutKAndR {
    /// Pass 1: convert Allman
    fn attach_open_braces(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let len = bytes.len();
        let mut edits = Vec::<TextEdit>::new();

        // Collect line starts
        let mut line_starts = Vec::<usize>::new();
        if len > 0 {
            line_starts.push(0usize);
            for (i,&b) in bytes.iter().enumerate().take(len) {
                if b == b'\n' && i + 1 < len {
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
            for (i_offset, &b) in bytes[next_start..len].iter().enumerate() {
                let i = i_offset + next_start;
                if b == b'\n' {
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
            let newline_pos = line_end; // index of '\n' after header line
            let remove_start = newline_pos;

            // Preserve the newline after the brace so the next line stays on its own line
            let mut nl_end = next_end;
            if nl_end < len && is_newline(bytes[nl_end]) {
                nl_end += 1;
                // handle CRLF as best we can
                if nl_end < len && bytes[nl_end] == b'\n' {
                    nl_end += 1;
                }
            }
            let remove_end = nl_end;

            // Simple attach: " {\n"
            let replacement = " {\n".to_string();

            edits.push(TextEdit {
                start_byte: remove_start,
                end_byte: remove_end,
                replacement,
            });
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }

    /// Pass 2: rewrite
    fn join_else_blocks(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let len = bytes.len();
        let mut edits = Vec::<TextEdit>::new();

        // Collect line starts again on the updated buffer
        let mut line_starts = Vec::<usize>::new();
        if len > 0 {
            line_starts.push(0usize);
            for (i, &b) in bytes.iter().enumerate().take(len) {
                if b == b'\n' && i + 1 < len {
                    line_starts.push(i + 1);
                }
            }
        }

        for win in line_starts.windows(3) {
            let l1_start = win[0]; // line with '}'
            let l2_start = win[1]; // line with 'else'
            let l3_start = win[2]; // line with '{'

            let (_, l1_line) = line_slice(&bytes, l1_start, len);
            let (_, l2_line) = line_slice(&bytes, l2_start, len);
            let (l3_nl, l3_line) = line_slice(&bytes, l3_start, len);

            // Skip comments entirely
            if is_line_comment(l1_line) || is_line_comment(l2_line) || is_line_comment(l3_line) {
                continue;
            }

            // Must be exactly "}", "else", "{"
            if !is_exact_token(l1_line, b"}") {
                continue;
            }
            if !is_exact_token(l2_line, b"else") {
                continue;
            }
            if !is_exact_token(l3_line, b"{") {
                continue;
            }

            // Require same indentation on all three lines
            let indent1 = leading_ws_len(l1_line);
            let indent2 = leading_ws_len(l2_line);
            let indent3 = leading_ws_len(l3_line);
            if indent1 != indent2 || indent2 != indent3 {
                continue;
            }

            let indent_bytes = &l1_line[..indent1];
            let indent_str = String::from_utf8(indent_bytes.to_vec()).unwrap_or_default();

            // Replacement: "<indent>} else {\n"
            let replacement = format!("{indent_str}}} else {{\n");

            // Replace from start of '}' line through newline after '{' line
            let mut replace_end = l3_nl;
            if replace_end < len && bytes[replace_end] == b'\n' {
                replace_end += 1;
            }

            edits.push(TextEdit {
                start_byte: l1_start,
                end_byte: replace_end,
                replacement,
            });
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

impl Rule for BlockLayoutKAndR {
    fn name(&self) -> &'static str {
        "block_layout_kandr"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        // 1) Attach `{` to "header" lines (x =, if (...), etc.)
        let n1 = self.attach_open_braces(cx)?;
        // 2) On the updated text, join `}\nelse\n{` into `} else {`
        let n2 = self.join_else_blocks(cx)?;
        Ok(n1 + n2)
    }
}
