use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

const MAX_LINE_WIDTH: usize = 80;

const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

const fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
}

fn is_ident_char(b: u8) -> bool {
    (b'A'..=b'Z').contains(&b)
        || (b'a'..=b'z').contains(&b)
        || (b'0'..=b'9').contains(&b)
        || b == b'_'
}

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

    fn in_comment_or_string(&self) -> bool {
        self.in_line || self.in_block || self.in_single || self.in_double
    }

    fn step(&mut self, b: u8) {
        if self.in_line {
            if is_newline(b) {
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

fn match_paren(bytes: &[u8], open: usize) -> Option<usize> {
    let len = bytes.len();
    let mut depth = 0usize;
    let mut cs = CommentState::new();

    let mut i = open;
    while i < len {
        let b = bytes[i];
        cs.step(b);

        if cs.in_comment_or_string() {
            i += 1;
            continue;
        }

        if b == b'(' {
            depth += 1;
        } else if b == b')' {
            if depth == 0 {
                return None;
            }
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
    let len = bytes.len();
    let mut depth = 0usize;
    let mut cs = CommentState::new();

    let mut i = open;
    while i < len {
        let b = bytes[i];
        cs.step(b);

        if cs.in_comment_or_string() {
            i += 1;
            continue;
        }

        if b == b'{' {
            depth += 1;
        } else if b == b'}' {
            if depth == 0 {
                return None;
            }
            depth -= 1;
            if depth == 0 {
                return Some(i);
            }
        }

        i += 1;
    }
    None
}

fn trim_ascii_slice(s: &str) -> &str {
    let bytes = s.as_bytes();
    let mut start = 0;
    let mut end = bytes.len();

    while start < end && (bytes[start] as char).is_whitespace() {
        start += 1;
    }
    while end > start && (bytes[end - 1] as char).is_whitespace() {
        end -= 1;
    }

    &s[start..end]
}

pub struct CompactShortIfTrailingClosures;

impl CompactShortIfTrailingClosures {
    fn try_compact_at(bytes: &[u8], start: usize) -> Option<TextEdit> {
        let len = bytes.len();

        // "if" token
        if start + 1 >= len || bytes[start] != b'i' || bytes[start + 1] != b'f' {
            return None;
        }

        // ensure it's not part of an identifier (diff, iffy, etc.)
        if start > 0 {
            let prev = bytes[start - 1];
            if is_ident_char(prev) {
                return None;
            }
        }
        if start + 2 < len {
            let next = bytes[start + 2];
            if is_ident_char(next) {
                return None;
            }
        }

        // after "if", expect spaces/tabs then '(' (on same line)
        let mut i = start + 2;
        while i < len && is_space(bytes[i]) {
            i += 1;
        }
        if i >= len || bytes[i] != b'(' {
            return None;
        }
        let cond_open = i;
        let cond_close = match match_paren(bytes, cond_open) {
            Some(c) => c,
            None => return None,
        };

        // condition must be single-line
        if (cond_open + 1..cond_close).any(|k| is_newline(bytes[k])) {
            return None;
        }

        // skip whitespace / newlines to first block
        i = cond_close + 1;
        while i < len && (is_space(bytes[i]) || is_newline(bytes[i])) {
            i += 1;
        }
        if i >= len || bytes[i] != b'{' {
            return None;
        }
        let block1_open = i;
        let block1_close = match match_brace(bytes, block1_open) {
            Some(c) => c,
            None => return None,
        };

        // first block body must be single-line
        if (block1_open + 1..block1_close).any(|k| is_newline(bytes[k])) {
            return None;
        }

        // skip whitespace / newlines to second block
        i = block1_close + 1;
        while i < len && (is_space(bytes[i]) || is_newline(bytes[i])) {
            i += 1;
        }
        if i >= len || bytes[i] != b'{' {
            return None;
        }
        let block2_open = i;
        let block2_close = match match_brace(bytes, block2_open) {
            Some(c) => c,
            None => return None,
        };

        // second block body must be single-line
        if (block2_open + 1..block2_close).any(|k| is_newline(bytes[k])) {
            return None;
        }

        // optional semicolon after second block
        let mut after = block2_close + 1;
        let mut has_semi = false;
        while after < len && is_space(bytes[after]) {
            after += 1;
        }
        if after < len && bytes[after] == b';' {
            has_semi = true;
            after += 1;
        }

        // NEW: if the whole if-statement is already single-line,
        // don't touch it. The compactor is only for multi-line → one-line.
        if (start..after).all(|k| !is_newline(bytes[k])) {
            return None;
        }

        // Determine the line for width calculation
        let mut line_start = start;
        while line_start > 0 && !is_newline(bytes[line_start - 1]) {
            line_start -= 1;
        }
        let mut line_end = after;
        while line_end < len && !is_newline(bytes[line_end]) {
            line_end += 1;
        }

        // Extract pieces as UTF-8
        let cond_body = std::str::from_utf8(&bytes[cond_open + 1..cond_close]).ok()?;
        let cond_body = trim_ascii_slice(cond_body);

        let b1_body = std::str::from_utf8(&bytes[block1_open + 1..block1_close]).ok()?;
        let b1_body = trim_ascii_slice(b1_body);

        let b2_body = std::str::from_utf8(&bytes[block2_open + 1..block2_close]).ok()?;
        let b2_body = trim_ascii_slice(b2_body);

        let mut replacement = String::new();
        replacement.push_str("if ");
        replacement.push('(');
        replacement.push_str(cond_body);
        replacement.push(')');
        replacement.push(' ');
        replacement.push('{');
        replacement.push(' ');
        replacement.push_str(b1_body);
        replacement.push(' ');
        replacement.push('}');
        replacement.push(' ');
        replacement.push('{');
        replacement.push(' ');
        replacement.push_str(b2_body);
        replacement.push('}');
        if has_semi {
            replacement.push(';');
        }

        // width check
        let old_segment_len = after - start; // from 'i' to after optional ';'
        let old_line_len = line_end - line_start;
        let new_line_len = old_line_len - old_segment_len + replacement.len();

        if new_line_len > MAX_LINE_WIDTH {
            return None;
        }

        Some(TextEdit {
            start_byte: start,
            end_byte: after,
            replacement,
        })
    }
}

impl Rule for CompactShortIfTrailingClosures {
    fn name(&self) -> &'static str {
        "compact_short_if_trailing_closures"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes();
        let bytes: &[u8] = src.as_slice();
        let len = bytes.len();

        let mut edits = Vec::new();
        let mut cs = CommentState::new();
        let mut i = 0;

        while i < len {
            let b = bytes[i];
            cs.step(b);

            if cs.in_comment_or_string() {
                i += 1;
                continue;
            }

            if b == b'i' && i + 1 < len && bytes[i + 1] == b'f' {
                if let Some(edit) = Self::try_compact_at(bytes, i) {
                    // skip over replaced segment; we only generate one edit per `if`
                    let skip_to = edit.end_byte;
                    edits.push(edit);
                    i = skip_to;
                    continue;
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
