use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

fn is_newline(b: u8) -> bool {
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
    fn new() -> Self {
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

/// Find the matching ')' for the '(' at `open`.
fn match_paren(bytes: &[u8], open: usize) -> Option<usize> {
    let len = bytes.len();
    let mut depth: isize = 1;
    let mut cs = CommentState::new();

    for i in open + 1..len {
        let b = bytes[i];
        cs.step(b);
        if cs.in_comment_or_string() {
            continue;
        }

        if b == b'(' {
            depth += 1;
        } else if b == b')' {
            depth -= 1;
            if depth == 0 {
                return Some(i);
            }
        }
    }
    None
}

/// Quick check: is there *any* newline between open and close?
fn is_multiline(bytes: &[u8], open: usize, close: usize) -> bool {
    bytes[open + 1..close]
        .iter()
        .any(|&b| is_newline(b))
}

/// Does this `( ... )` look like an event literal, i.e. has a top-level `:`?
fn has_top_level_event_colon(bytes: &[u8], open: usize, close: usize) -> bool {
    let mut cs = CommentState::new();
    let mut par: isize = 1;
    let mut br: isize = 0;
    let mut brk: isize = 0;

    for i in open + 1..close {
        let b = bytes[i];
        cs.step(b);
        if cs.in_comment_or_string() {
            continue;
        }

        match b {
            b'(' => par += 1,
            b')' => par -= 1,
            b'{' => br += 1,
            b'}' => br -= 1,
            b'[' => brk += 1,
            b']' => brk -= 1,
            b':' if par == 1 && br == 0 && brk == 0 => {
                // top-level colon → treat as event
                return true;
            }
            _ => {}
        }
    }
    false
}

/// Decide whether the comma at `comma_idx` is followed by another
/// top-level `key: value` pair inside this event.
fn comma_starts_event_key(bytes: &[u8], comma_idx: usize, open: usize, close: usize) -> bool {
    let mut cs = CommentState::new();
    let mut par: isize = 1;
    let mut br: isize = 0;
    let mut brk: isize = 0;

    // Start just after the comma, skipping whitespace and newlines.
    let mut j = comma_idx + 1;
    while j < close && (is_space(bytes[j]) || is_newline(bytes[j])) {
        cs.step(bytes[j]);
        j += 1;
    }
    if j >= close {
        return false;
    }

    // Now scan until we either see a top-level ':' (good) or hit another
    // top-level comma / closing paren without seeing ':' (not a key).
    for k in j..close {
        let c = bytes[k];
        cs.step(c);
        if cs.in_comment_or_string() {
            continue;
        }

        match c {
            b'(' => par += 1,
            b')' => {
                par -= 1;
                if par < 1 {
                    return false;
                }
            }
            b'{' => br += 1,
            b'}' => br -= 1,
            b'[' => brk += 1,
            b']' => brk -= 1,
            b':' if par == 1 && br == 0 && brk == 0 => {
                return true;
            }
            b',' | b')' if par == 1 && br == 0 && brk == 0 => {
                // hit separator/end before any colon
                return false;
            }
            _ => {}
        }
    }

    false
}

/// Split an event like `(freq: 440, amp: 0.1, pan: -0.5)` into one key per line,
/// preserving indentation and avoiding comments/strings.
fn split_event_items(bytes: &[u8], open: usize, close: usize, edits: &mut Vec<TextEdit>) {
    let mut cs = CommentState::new();
    let mut par: isize = 1;
    let mut br: isize = 0;
    let mut brk: isize = 0;
    let mut commas: Vec<usize> = Vec::new();

    // 1) collect top-level commas inside this `( ... )`
    for i in open + 1..close {
        let b = bytes[i];
        cs.step(b);
        if cs.in_comment_or_string() {
            continue;
        }

        match b {
            b'(' => par += 1,
            b')' => par -= 1,
            b'{' => br += 1,
            b'}' => br -= 1,
            b'[' => brk += 1,
            b']' => brk -= 1,
            b',' if par == 1 && br == 0 && brk == 0 => {
                commas.push(i);
            }
            _ => {}
        }
    }

    if commas.is_empty() {
        return;
    }

    // 2) determine indentation based on the first key line
    let mut cs2 = CommentState::new();
    par = 1;
    br = 0;
    brk = 0;
    let mut indent = String::new();

    'outer: for i in open + 1..close {
        let b = bytes[i];
        cs2.step(b);
        if cs2.in_comment_or_string() {
            continue;
        }

        match b {
            b'(' => par += 1,
            b')' => par -= 1,
            b'{' => br += 1,
            b'}' => br -= 1,
            b'[' => brk += 1,
            b']' => brk -= 1,
            b':' if par == 1 && br == 0 && brk == 0 => {
                // Back up to line start to capture indent.
                let mut line_start = i;
                while line_start > 0 && bytes[line_start - 1] != b'\n' {
                    line_start -= 1;
                }
                let mut indent_end = line_start;
                while indent_end < i && (bytes[indent_end] == b' ' || bytes[indent_end] == b'\t') {
                    indent_end += 1;
                }
                indent = String::from_utf8(bytes[line_start..indent_end].to_vec()).unwrap_or_default();
                break 'outer;
            }
            _ => {}
        }
    }

    // 3) rewrite commas that introduce a new key so that each key starts on its own line
    for &comma_idx in &commas {
        // Skip if what follows is already on a new line.
        let mut j = comma_idx + 1;
        while j < close && is_space(bytes[j]) {
            j += 1;
        }
        if j < close && is_newline(bytes[j]) {
            continue;
        }

        // Only touch commas that clearly start another event key.
        if !comma_starts_event_key(bytes, comma_idx, open, close) {
            continue;
        }

        // Extend replacement to eat any spaces after the comma.
        let mut end = comma_idx + 1;
        while end < close && is_space(bytes[end]) {
            end += 1;
        }

        let repl = if indent.is_empty() {
            ",\n".to_string()
        } else {
            format!(",\n{}", indent)
        };

        edits.push(TextEdit {
            start_byte: comma_idx,
            end_byte: end,
            replacement: repl,
        });
    }
}

pub struct MultiLineEventsOnePerLine;

impl Rule for MultiLineEventsOnePerLine {
    fn name(&self) -> &'static str {
        "multi_line_events_one_per_line"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes();
        let bytes: &[u8] = &src;
        let len = bytes.len();

        let mut edits: Vec<TextEdit> = Vec::new();
        let mut cs = CommentState::new();

        let mut i = 0usize;
        while i < len {
            let b = bytes[i];
            cs.step(b);

            // Ignore anything inside comments/strings entirely.
            if cs.in_comment_or_string() {
                i += 1;
                continue;
            }

            if b == b'(' {
                if let Some(close) = match_paren(bytes, i) {
                    // Only bother with genuinely multi-line parens that look like events.
                    if is_multiline(bytes, i, close) && has_top_level_event_colon(bytes, i, close) {
                        split_event_items(bytes, i, close, &mut edits);
                    }
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

