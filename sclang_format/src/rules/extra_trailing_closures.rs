// src/rules/extra_trailing_closures.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

const fn is_ident_char(b: u8) -> bool {
    b.is_ascii_alphanumeric() || b == b'_'
}

#[derive(Default)]
struct ScanState {
    in_line_comment: bool,
    in_block_comment: bool,
    in_single_str: bool,
    in_double_str: bool,
}

impl ScanState {
    fn step(&mut self, bytes: &[u8], i: usize) {
        let b = bytes[i];

        if self.in_line_comment {
            if b == b'\n' {
                self.in_line_comment = false;
            }
            return;
        }

        if self.in_block_comment {
            if b == b'*' && i + 1 < bytes.len() && bytes[i + 1] == b'/' {
                self.in_block_comment = false;
            }
            return;
        }

        if self.in_single_str {
            if b == b'\\' && i + 1 < bytes.len() {
                // skip escaped char
            } else if b == b'\'' {
                self.in_single_str = false;
            }
            return;
        }

        if self.in_double_str {
            if b == b'\\' && i + 1 < bytes.len() {
                // skip escaped char
            } else if b == b'"' {
                self.in_double_str = false;
            }
            return;
        }

        if b == b'/' && i + 1 < bytes.len() {
            if bytes[i + 1] == b'/' {
                self.in_line_comment = true;
                return;
            }
            if bytes[i + 1] == b'*' {
                self.in_block_comment = true;
                return;
            }
        }
        if b == b'\'' {
            self.in_single_str = true;
            return;
        }
        if b == b'"' {
            self.in_double_str = true;
        }
    }

    const fn in_comment_or_string(&self) -> bool {
        self.in_line_comment || self.in_block_comment || self.in_single_str || self.in_double_str
    }
}

fn match_paren(bytes: &[u8], open: usize) -> Option<usize> {
    let mut depth: isize = 0;
    let mut i = open;
    let len = bytes.len();
    while i < len {
        let b = bytes[i];
        if b == b'(' {
            depth += 1;
        } else if b == b')' {
            depth -= 1;
            if depth == 0 {
                return Some(i);
            }
        }
        i += 1;
    }
    None
}

fn match_brace(bytes: &[u8], open: usize) -> Option<usize> {
    let mut depth: isize = 0;
    let mut i = open;
    let len = bytes.len();
    while i < len {
        let b = bytes[i];
        if b == b'{' {
            depth += 1;
        } else if b == b'}' {
            depth -= 1;
            if depth == 0 {
                return Some(i);
            }
        }
        i += 1;
    }
    None
}

/// .collect({ |x| ... })  →  .collect { |x| ... }
/// (same for select/reject/inject/detect)
fn rewrite_method_trailing_block(bytes: &[u8], dot: usize, name: &str) -> Option<TextEdit> {
    let len = bytes.len();
    let name_bytes = name.as_bytes();
    let name_len = name_bytes.len();

    let start = dot + 1;
    if start + name_len >= len {
        return None;
    }
    if &bytes[start..start + name_len] != name_bytes {
        return None;
    }
    // Make sure we don't match ".collectX"
    let after_name = start + name_len;
    if after_name < len && is_ident_char(bytes[after_name]) {
        return None;
    }

    let mut i = after_name;
    // skip whitespace
    while i < len
        && (bytes[i] == b' ' || bytes[i] == b'\t' || bytes[i] == b'\n' || bytes[i] == b'\r')
    {
        i += 1;
    }
    if i >= len || bytes[i] != b'(' {
        return None;
    }
    let open = i;
    let close = match_paren(bytes, open)?;

    // Trim content inside parens.
    let mut inner_start = open + 1;
    let mut inner_end = close;
    while inner_start < inner_end
        && (bytes[inner_start] == b' '
            || bytes[inner_start] == b'\t'
            || bytes[inner_start] == b'\n'
            || bytes[inner_start] == b'\r')
    {
        inner_start += 1;
    }
    while inner_end > inner_start
        && (bytes[inner_end - 1] == b' '
            || bytes[inner_end - 1] == b'\t'
            || bytes[inner_end - 1] == b'\n'
            || bytes[inner_end - 1] == b'\r')
    {
        inner_end -= 1;
    }
    if inner_start >= inner_end {
        return None;
    }

    // Single arg must be a block, with no top-level commas.
    if bytes[inner_start] != b'{' {
        return None;
    }
    let block_end = match_brace(bytes, inner_start)?;
    if block_end + 1 != inner_end {
        // Extra stuff after block → more args, bail.
        return None;
    }

    // Guard against commas outside the block.
    let mut depth: isize = 0;
    let mut k = open + 1;
    while k < close {
        let b = bytes[k];
        if b == b'{' {
            depth += 1;
        } else if b == b'}' {
            depth -= 1;
        } else if b == b',' && depth == 0 {
            return None;
        }
        k += 1;
    }

    let block_src = std::str::from_utf8(&bytes[inner_start..inner_end]).ok()?;
    let replacement = format!(" {block_src}");

    Some(TextEdit {
        start_byte: open,
        end_byte: close + 1,
        replacement,
    })
}

fn is_keyword_at(bytes: &[u8], idx: usize, kw: &[u8]) -> bool {
    let kw_len = kw.len();
    if idx + kw_len > bytes.len() {
        return false;
    }
    if &bytes[idx..idx + kw_len] != kw {
        return false;
    }
    if idx > 0 && is_ident_char(bytes[idx - 1]) {
        return false;
    }
    if idx + kw_len < bytes.len() && is_ident_char(bytes[idx + kw_len]) {
        return false;
    }
    true
}

/// while({ cond }, { body })  →  while { cond } { body }
fn rewrite_while_call(bytes: &[u8], idx: usize) -> Option<TextEdit> {
    if !is_keyword_at(bytes, idx, b"while") {
        return None;
    }

    let len = bytes.len();
    let mut i = idx + "while".len();

    // skip whitespace
    while i < len
        && (bytes[i] == b' ' || bytes[i] == b'\t' || bytes[i] == b'\n' || bytes[i] == b'\r')
    {
        i += 1;
    }
    if i >= len || bytes[i] != b'(' {
        return None;
    }
    let open = i;
    let close = match_paren(bytes, open)?;

    // Parse: while({cond}, {body})
    let mut p = open + 1;
    while p < close
        && (bytes[p] == b' ' || bytes[p] == b'\t' || bytes[p] == b'\n' || bytes[p] == b'\r')
    {
        p += 1;
    }
    if p >= close || bytes[p] != b'{' {
        return None;
    }
    let cond_start = p;
    let cond_end = match_brace(bytes, cond_start)?;

    let mut q = cond_end + 1;
    while q < close
        && (bytes[q] == b' ' || bytes[q] == b'\t' || bytes[q] == b'\n' || bytes[q] == b'\r')
    {
        q += 1;
    }
    if q >= close || bytes[q] != b',' {
        return None;
    }
    q += 1; // past comma

    while q < close
        && (bytes[q] == b' ' || bytes[q] == b'\t' || bytes[q] == b'\n' || bytes[q] == b'\r')
    {
        q += 1;
    }
    if q >= close || bytes[q] != b'{' {
        return None;
    }
    let body_start = q;
    let body_end = match_brace(bytes, body_start)?;

    let mut r = body_end + 1;
    while r < close
        && (bytes[r] == b' ' || bytes[r] == b'\t' || bytes[r] == b'\n' || bytes[r] == b'\r')
    {
        r += 1;
    }
    if r != close {
        // Extra tokens inside the parens → bail.
        return None;
    }

    let cond_src = std::str::from_utf8(&bytes[cond_start..=cond_end]).ok()?;
    let body_src = std::str::from_utf8(&bytes[body_start..=body_end]).ok()?;
    let replacement = format!(" {cond_src} {body_src}");

    Some(TextEdit {
        start_byte: open,
        end_byte: close + 1,
        replacement,
    })
}

pub struct ExtraTrailingClosures;

impl Rule for ExtraTrailingClosures {
    fn name(&self) -> &'static str {
        "extra_trailing_closures"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes();
        let bytes: &[u8] = &src;
        let len = bytes.len();
        let mut edits: Vec<TextEdit> = Vec::new();
        let mut st = ScanState::default();

        let mut i = 0usize;
        while i < len {
            st.step(bytes, i);
            if st.in_comment_or_string() {
                i += 1;
                continue;
            }

            let b = bytes[i];

            if b == b'.' {
                // Try each method name.
                if b == b'.' {
                    // Try each method name.
                    for &name in &["collect", "select", "reject", "inject", "detect"] {
                        if let Some(edit) = rewrite_method_trailing_block(bytes, i, name) {
                            let jump = edit.end_byte;
                            edits.push(edit);
                            i = jump;
                            break;
                        }
                    }
                    i += 1;
                    continue;
                }
                i += 1;
                continue;
            } else if b == b'w'
                && let Some(edit) = rewrite_while_call(bytes, i)
            {
                let jump = edit.end_byte;
                edits.push(edit);
                i = jump;
                continue;
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
