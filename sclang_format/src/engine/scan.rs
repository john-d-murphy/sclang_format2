// src/engine/scan.rs

/// Find the matching closing delimiter for `open_ch` at `open_idx`.
///
/// Accounts for nested pairs of the same delimiter. Does **not** skip
/// strings/comments; use only when you're already sure about context.
pub fn match_delim(src: &[u8], open_idx: usize, open_ch: u8, close_ch: u8) -> Option<usize> {
    let mut depth = 0i32;
    let mut i = open_idx;

    while i < src.len() {
        let b = src[i];
        if b == open_ch {
            depth += 1;
        } else if b == close_ch {
            depth -= 1;
            if depth == 0 {
                return Some(i);
            }
        }
        i += 1;
    }

    None
}

pub fn slice_has_newline(src: &[u8], lo: usize, hi: usize) -> bool {
    src[lo..hi].contains(&b'\n')
}

pub fn slice_has_comment(src: &[u8], lo: usize, hi: usize) -> bool {
    let mut i = lo;
    while i + 1 < hi {
        if src[i] == b'/' {
            let c2 = src[i + 1];
            if c2 == b'/' || c2 == b'*' {
                return true;
            }
        }
        i += 1;
    }
    false
}

/// Compute the spans of top-level comma-separated elements inside `open+1..close`.
///
/// This tracks (), {}, [] depth to avoid splitting on commas inside nested
/// structures (but does *not* know about comments/strings; if you need that,
/// layer your existing comment/string logic on top).
pub fn top_level_comma_spans(src: &[u8], open: usize, close: usize) -> Vec<(usize, usize)> {
    let mut spans = Vec::new();
    if close <= open + 1 {
        return spans;
    }

    let mut paren = 0i32;
    let mut brace = 0i32;
    let mut bracket = 0i32;

    let mut item_start = open + 1;
    let mut i = item_start;

    while i < close {
        match src[i] {
            b'(' => paren += 1,
            b')' => paren -= 1,
            b'{' => brace += 1,
            b'}' => brace -= 1,
            b'[' => bracket += 1,
            b']' => bracket -= 1,
            b',' if paren == 0 && brace == 0 && bracket == 0 => {
                spans.push((item_start, i));
                item_start = i + 1;
            }
            _ => {}
        }
        i += 1;
    }

    if item_start < close {
        spans.push((item_start, close));
    }

    spans
}
