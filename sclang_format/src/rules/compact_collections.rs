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
        // line comments
        if self.in_line {
            if is_newline(b) {
                self.in_line = false;
            }
            self.prev = b;
            return;
        }

        // block comments
        if self.in_block {
            if self.prev == b'*' && b == b'/' {
                self.in_block = false;
            }
            self.prev = b;
            return;
        }

        // single-quoted string
        if self.in_single {
            if b == b'\'' && self.prev != b'\\' {
                self.in_single = false;
            }
            self.prev = b;
            return;
        }

        // double-quoted string
        if self.in_double {
            if b == b'"' && self.prev != b'\\' {
                self.in_double = false;
            }
            self.prev = b;
            return;
        }

        // not inside anything yet
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

fn slice_has_newline(bytes: &[u8], start: usize, end: usize) -> bool {
    let mut i = start;
    while i < end {
        if is_newline(bytes[i]) {
            return true;
        }
        i += 1;
    }
    false
}

fn slice_has_comment(bytes: &[u8], start: usize, end: usize) -> bool {
    let mut cs = CommentState::new();
    let mut i = start;
    while i < end {
        let b = bytes[i];
        cs.step(b);
        // consider either // or /* as enough to bail
        if cs.in_line || cs.in_block {
            return true;
        }
        i += 1;
    }
    false
}

/// match matching delimiter (e.g. '[' → ']'), ignoring anything inside comments/strings.
fn match_delim(bytes: &[u8], open: usize, open_b: u8, close_b: u8) -> Option<usize> {
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

        if b == open_b {
            depth += 1;
        } else if b == close_b {
            if depth == 0 {
                // malformed, but bail
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

/// True if there is a top-level `:` inside `( ... )`, treating that as an event.
fn has_top_level_event_colon(bytes: &[u8], open: usize, close: usize) -> bool {
    let mut cs = CommentState::new();
    let mut par_depth = 0i32;
    let mut square_depth = 0i32;
    let mut brace_depth = 0i32;

    let mut i = open;
    while i <= close {
        let b = bytes[i];
        cs.step(b);

        if cs.in_comment_or_string() {
            i += 1;
            continue;
        }

        match b {
            b'(' => par_depth += 1,
            b')' => par_depth -= 1,
            b'[' => square_depth += 1,
            b']' => square_depth -= 1,
            b'{' => brace_depth += 1,
            b'}' => brace_depth -= 1,
            b':' => {
                if par_depth == 1 && square_depth == 0 && brace_depth == 0 {
                    return true;
                }
            }
            _ => {}
        }

        i += 1;
    }

    false
}

fn collect_top_level_elements(
    bytes: &[u8],
    inner_start: usize,
    inner_end: usize,
) -> Vec<(usize, usize)> {
    let mut cs = CommentState::new();
    let mut par_depth = 0i32;
    let mut square_depth = 0i32;
    let mut brace_depth = 0i32;

    let mut elems = Vec::new();
    let mut start = inner_start;

    let mut i = inner_start;
    while i < inner_end {
        let b = bytes[i];
        cs.step(b);

        if cs.in_comment_or_string() {
            i += 1;
            continue;
        }

        match b {
            b'(' => par_depth += 1,
            b')' => par_depth -= 1,
            b'[' => square_depth += 1,
            b']' => square_depth -= 1,
            b'{' => brace_depth += 1,
            b'}' => brace_depth -= 1,
            b',' => {
                if par_depth == 0 && square_depth == 0 && brace_depth == 0 {
                    // element boundary
                    elems.push((start, i));
                    start = i + 1;
                }
            }
            _ => {}
        }

        i += 1;
    }

    // last element
    if start < inner_end {
        elems.push((start, inner_end));
    }

    elems
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

pub struct CompactShortCollections;

impl CompactShortCollections {
    fn try_compact_array(bytes: &[u8], open: usize, close: usize, edits: &mut Vec<TextEdit>) {
        // Must be multi-line
        if !slice_has_newline(bytes, open + 1, close) {
            return;
        }

        // Skip arrays that contain comments
        if slice_has_comment(bytes, open + 1, close) {
            return;
        }

        // Collect top-level elements
        let elems = collect_top_level_elements(bytes, open + 1, close);
        let mut trimmed_parts = Vec::new();

        for (s, e) in elems {
            let raw = &bytes[s..e];
            if let Ok(text) = std::str::from_utf8(raw) {
                let trimmed = trim_ascii_slice(text);
                if !trimmed.is_empty() {
                    trimmed_parts.push(trimmed.to_string());
                }
            } else {
                // non-UTF8; bail conservatively
                return;
            }
        }

        if trimmed_parts.len() < 2 {
            // nothing to compact
            return;
        }

        let inner_joined = trimmed_parts.join(", ");
        let replacement = format!("[{}]", inner_joined);

        // Compute line width with replacement
        let len = bytes.len();
        let mut line_start = open;
        while line_start > 0 && !is_newline(bytes[line_start - 1]) {
            line_start -= 1;
        }
        let mut line_end = close + 1;
        while line_end < len && !is_newline(bytes[line_end]) {
            line_end += 1;
        }

        let old_inner_len = close + 1 - open;
        let old_line_len = line_end - line_start;
        let new_line_len = old_line_len - old_inner_len + replacement.len();

        if new_line_len <= MAX_LINE_WIDTH {
            edits.push(TextEdit {
                start_byte: open,
                end_byte: close + 1,
                replacement,
            });
        }
    }

    fn try_compact_event(bytes: &[u8], open: usize, close: usize, edits: &mut Vec<TextEdit>) {
        // Must be multi-line
        if !slice_has_newline(bytes, open + 1, close) {
            return;
        }

        // Skip events that contain comments
        if slice_has_comment(bytes, open + 1, close) {
            return;
        }

        // Only treat things that *really* look like events
        if !has_top_level_event_colon(bytes, open, close) {
            return;
        }

        // Collect top-level comma-separated "key: value" entries
        let elems = collect_top_level_elements(bytes, open + 1, close);
        let mut trimmed_parts = Vec::new();

        for (s, e) in elems {
            let raw = &bytes[s..e];
            if let Ok(text) = std::str::from_utf8(raw) {
                let trimmed = trim_ascii_slice(text);
                if !trimmed.is_empty() {
                    trimmed_parts.push(trimmed.to_string());
                }
            } else {
                return;
            }
        }

        if trimmed_parts.len() < 2 {
            return;
        }

        let inner_joined = trimmed_parts.join(", ");
        let replacement = format!("({})", inner_joined);

        // Compute line width with replacement
        let len = bytes.len();
        let mut line_start = open;
        while line_start > 0 && !is_newline(bytes[line_start - 1]) {
            line_start -= 1;
        }
        let mut line_end = close + 1;
        while line_end < len && !is_newline(bytes[line_end]) {
            line_end += 1;
        }

        let old_inner_len = close + 1 - open;
        let old_line_len = line_end - line_start;
        let new_line_len = old_line_len - old_inner_len + replacement.len();

        if new_line_len <= MAX_LINE_WIDTH {
            edits.push(TextEdit {
                start_byte: open,
                end_byte: close + 1,
                replacement,
            });
        }
    }
}

impl Rule for CompactShortCollections {
    fn name(&self) -> &'static str {
        "compact_short_collections"
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

            if b == b'[' {
                if let Some(close) = match_delim(bytes, i, b'[', b']') {
                    Self::try_compact_array(bytes, i, close, &mut edits);
                    // skip past this array; we won't touch its interior again in this pass
                    i = close + 1;
                    continue;
                }
            } else if b == b'(' {
                if let Some(close) = match_delim(bytes, i, b'(', b')') {
                    Self::try_compact_event(bytes, i, close, &mut edits);
                    i = close + 1;
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
