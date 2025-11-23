// src/rules/arg_to_pipe.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

fn is_line_comment(line: &[u8]) -> bool {
    let mut i = 0;
    while i < line.len() && is_space(line[i]) {
        i += 1;
    }
    i + 1 < line.len() && line[i] == b'/' && line[i + 1] == b'/'
}

pub struct ArgToPipeParams;

impl Rule for ArgToPipeParams {
    fn name(&self) -> &'static str {
        "arg_to_pipe_params"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let len = bytes.len();
        let buf: &[u8] = &bytes;

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

        let mut edits: Vec<TextEdit> = Vec::new();

        // We always look at pairs: (header line, arg line)
        for idx in 1..line_starts.len() {
            let l1_start = line_starts[idx - 1];
            let l2_start = line_starts[idx];

            // ----- header line [l1_start, l1_end) -----
            let mut l1_end = len;
            for (offset, &b) in buf[l1_start..].iter().enumerate() {
                if b == b'\n' {
                    l1_end = l1_start + offset;
                    break;
                }
            }
            let line1 = &buf[l1_start..l1_end];

            // last non-whitespace char on header must be '{'
            let mut last_non_ws: Option<usize> = None;
            for (j, &b) in line1.iter().enumerate() {
                if !is_space(b) {
                    last_non_ws = Some(j);
                }
            }
            let Some(last_idx) = last_non_ws else {
                continue;
            };
            if line1[last_idx] != b'{' {
                continue;
            }

            // ----- candidate arg line [l2_start, l2_end) -----
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

            // find first non-space on arg line
            let mut i2 = 0usize;
            while i2 < line2.len() && is_space(line2[i2]) {
                i2 += 1;
            }
            if i2 + 3 > line2.len() {
                continue;
            }

            // must start with "arg" and then whitespace
            if &line2[i2..i2 + 3] != b"arg" {
                continue;
            }
            if i2 + 3 < line2.len() && !is_space(line2[i2 + 3]) {
                continue;
            }

            // locate first ';' on the arg line
            let mut semi_rel: Option<usize> = None;
            for (j, &b) in line2.iter().enumerate() {
                if b == b';' {
                    semi_rel = Some(j);
                    break;
                }
            }
            let Some(semi_pos) = semi_rel else {
                continue;
            };

            // slice between "arg" and ';'
            let mut arg_start = i2 + 3;
            while arg_start < semi_pos && is_space(line2[arg_start]) {
                arg_start += 1;
            }
            if arg_start >= semi_pos {
                continue;
            }

            let arg_slice = &line2[arg_start..semi_pos];
            let arg_str = String::from_utf8(arg_slice.to_vec()).unwrap_or_default();
            let arg_trim = arg_str.trim();
            if arg_trim.is_empty() {
                continue;
            }

            // For now we keep defaults as-is; other rules clean up spacing.
            let pipe_str = format!("|{arg_trim}|");

            // build new header line: original header (without trailing ws) + space + pipe + newline
            let header_str = String::from_utf8(line1.to_vec()).unwrap_or_default();
            let trimmed_end = header_str.trim_end_matches([' ', '\t']).len();
            let (header_prefix, _) = header_str.split_at(trimmed_end);
            let new_header_line = format!("{header_prefix} {pipe_str}\n");

            // compute end indices including newline
            let mut header_end_nl = l1_end;
            if header_end_nl < len && buf[header_end_nl] == b'\n' {
                header_end_nl += 1;
            }
            let mut arg_end_nl = l2_end;
            if arg_end_nl < len && buf[arg_end_nl] == b'\n' {
                arg_end_nl += 1;
            }

            // replace header line with header+pipes
            edits.push(TextEdit {
                start_byte: l1_start,
                end_byte: header_end_nl,
                replacement: new_header_line,
            });

            // delete the arg line entirely
            edits.push(TextEdit {
                start_byte: l2_start,
                end_byte: arg_end_nl,
                replacement: String::new(),
            });
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
