use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

fn is_line_comment(line: &[u8]) -> bool {
    // find first non-WS char
    let mut i = 0;
    while i < line.len() && is_space(line[i]) {
        i += 1;
    }
    i + 1 < line.len() && line[i] == b'/' && line[i + 1] == b'/'
}

pub struct PipeParamOnBraceLine;

impl Rule for PipeParamOnBraceLine {
    fn name(&self) -> &'static str {
        "pipe_param_on_brace_line"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let len = bytes.len();
        let buf: &[u8] = &bytes;
        let mut edits: Vec<TextEdit> = Vec::new();

        // collect line starts
        let mut line_starts: Vec<usize> = Vec::new();
        if len > 0 {
            line_starts.push(0);
            for (i, &b) in bytes.iter().enumerate().take(len) {
                if b == b'\n' && i + 1 < len {
                    line_starts.push(i + 1);
                }
            }
        }

        for window in line_starts.windows(2) {
            let l1_start = window[0];
            let l2_start = window[1];

            // line 1
            let mut l1_end = len;
            for (offset, &b) in buf[l1_start..].iter().enumerate() {
                if b == b'\n' {
                    l1_end = l1_start + offset;
                    break;
                }
            }
            let line1 = &buf[l1_start..l1_end];
            if is_line_comment(line1) {
                continue;
            }

            // must contain '{' and NOT contain any '|'
            let brace_pos_opt = line1.iter().position(|&b| b == b'{');
            if brace_pos_opt.is_none() {
                continue;
            }
            if line1.contains(&b'|') {
                // already has pipes on the brace line, leave it
                continue;
            }

            // line 2
            let mut l2_end = len;
            for (offset, &b) in buf[l2_start..].iter().enumerate() {
                if b == b'\n' {
                    l2_end = l2_start + offset;
                    break;
                }
            }
            let line2 = &buf[l2_start..l2_end];
            if is_line_comment(line2) {
                continue;
            }

            // find first non-space on line2
            let mut i2 = 0usize;
            while i2 < line2.len() && is_space(line2[i2]) {
                i2 += 1;
            }
            if i2 >= line2.len() || line2[i2] != b'|' {
                continue; // not a pipe param line
            }

            // find closing pipe
            let mut j = i2 + 1;
            while j < line2.len() && line2[j] != b'|' {
                j += 1;
            }
            if j >= line2.len() || line2[j] != b'|' {
                continue; // no closing pipe, bail
            }

            // after closing pipe, only allow spaces/tabs (no extra code)
            let mut k = j + 1;
            while k < line2.len() && is_space(line2[k]) {
                k += 1;
            }
            if k != line2.len() {
                continue; // there is other stuff on the line, be conservative
            }

            // build replacement: "<line1> <pipe_list>\n"
            let line1_str = String::from_utf8(line1.to_vec()).unwrap_or_default();
            let pipe_str = String::from_utf8(line2[i2..=j].to_vec()).unwrap_or_default();

            let replacement = format!("{line1_str} {pipe_str}\n");

            // replace from start of line1 through end of line2 (including its newline)
            let mut replace_end = l2_end;
            if replace_end < len && buf[replace_end] == b'\n' {
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
