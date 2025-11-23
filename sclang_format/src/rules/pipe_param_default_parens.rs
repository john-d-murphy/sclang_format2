use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

/// Whitespace
fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

/// Simple literal classification
fn is_numeric_literal(s: &str) -> bool {
    let bytes = s.as_bytes();
    if bytes.is_empty() {
        return false;
    }

    let mut i = 0;
    if bytes[i] == b'+' || bytes[i] == b'-' {
        i += 1;
    }

    let mut has_digit = false;
    while i < bytes.len() && bytes[i].is_ascii_digit() {
        has_digit = true;
        i += 1;
    }

    if i < bytes.len() && bytes[i] == b'.' {
        i += 1;
        while i < bytes.len() && bytes[i].is_ascii_digit() {
            has_digit = true;
            i += 1;
        }
    }

    if !has_digit {
        return false;
    }

    if i < bytes.len() && (bytes[i] == b'e' || bytes[i] == b'E') {
        i += 1;
        if i < bytes.len() && (bytes[i] == b'+' || bytes[i] == b'-') {
            i += 1;
        }
        let mut exp_digit = false;
        while i < bytes.len() && bytes[i].is_ascii_digit() {
            exp_digit = true;
            i += 1;
        }
        if !exp_digit {
            return false;
        }
    }

    i == bytes.len()
}

fn is_symbol_literal(s: &str) -> bool {
    let mut chars = s.chars();
    match chars.next() {
        Some('\\') => {}
        _ => return false,
    }
    for ch in chars {
        if !(ch.is_ascii_alphanumeric() || ch == '_') {
            return false;
        }
    }
    true
}

fn is_string_literal(s: &str) -> bool {
    let bytes = s.as_bytes();
    bytes.len() >= 2 && bytes[0] == b'"' && *bytes.last().unwrap() == b'"'
}

fn is_already_parenthesized(s: &str) -> bool {
    let bytes = s.as_bytes();
    if bytes.len() < 2 || bytes[0] != b'(' || *bytes.last().unwrap() != b')' {
        return false;
    }

    let mut depth = 0i32;
    for (i, &b) in bytes.iter().enumerate() {
        match b {
            b'(' => depth += 1,
            b')' => {
                depth -= 1;
                if depth == 0 && i != bytes.len() - 1 {
                    // Closed before the end → outer parens don’t wrap the whole expr.
                    return false;
                }
            }
            _ => {}
        }
    }
    depth == 0
}

fn is_simple_default_expr(s: &str) -> bool {
    if s.is_empty() {
        return true;
    }
    if is_numeric_literal(s) {
        return true;
    }
    if is_symbol_literal(s) {
        return true;
    }
    if is_string_literal(s) {
        return true;
    }
    matches!(s, "true" | "false" | "nil")
}

/// Filter out ==, <=, >=, != etc.
fn is_assignment_eq(seg: &[u8], idx: usize) -> bool {
    let prev = if idx > 0 { seg[idx - 1] } else { b' ' };
    let next = seg.get(idx + 1).copied().unwrap_or(b' ');
    !(prev == b'=' || prev == b'<' || prev == b'>' || prev == b'!') && next != b'='
}

/// AST-based “are we in a string/comment?”
fn in_comment_or_string(root: &tree_sitter::Node, byte: usize) -> bool {
    let mut cur = root.descendant_for_byte_range(byte, byte + 1);
    while let Some(n) = cur {
        match n.kind() {
            "comment" | "block_comment" | "line_comment" | "string" => return true,
            _ => {}
        }
        cur = n.parent();
    }
    false
}

/// Same header detection idea as in `pipe_param_commas`:
/// - '|' not in string/comment
/// - '{' earlier on same line
/// - matching '|' on same line, not in string/comment
fn find_pipe_param_headers(buf: &[u8], root: &tree_sitter::Node) -> Vec<(usize, usize)> {
    let len = buf.len();
    let mut res = Vec::new();
    let mut i = 0;

    while i < len {
        if buf[i] == b'|' {
            if in_comment_or_string(root, i) {
                i += 1;
                continue;
            }

            // Search backwards on this line for '{'
            let mut j = i;
            let mut saw_open_brace = false;
            while j > 0 {
                j -= 1;
                let c = buf[j];
                if c == b'\n' {
                    break;
                }
                if c == b'{' {
                    saw_open_brace = true;
                    break;
                }
            }
            if !saw_open_brace {
                i += 1;
                continue;
            }

            // Search forwards on same line for closing '|'
            let start = i;
            let mut k = i + 1;
            let mut end_opt = None;
            while k < len {
                let c = buf[k];
                if c == b'\n' {
                    break;
                }
                if c == b'|' {
                    if in_comment_or_string(root, k) {
                        break;
                    }
                    end_opt = Some(k);
                    break;
                }
                k += 1;
            }

            if let Some(end) = end_opt {
                res.push((start, end));
                i = end + 1;
                continue;
            }
        }

        i += 1;
    }

    res
}

pub struct PipeParamDefaultParens;

impl Rule for PipeParamDefaultParens {
    fn name(&self) -> &'static str {
        "pipe_param_default_parens"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let buf: &[u8] = &bytes;
        let root = cx.tree.root_node();

        let mut edits: Vec<TextEdit> = Vec::new();

        for (pipe_l, pipe_r) in find_pipe_param_headers(buf, &root) {
            if pipe_r <= pipe_l + 1 {
                continue;
            }

            let seg_lo = pipe_l + 1;
            let seg_hi = pipe_r;
            let seg = &buf[seg_lo..seg_hi];

            for (i, &b) in seg.iter().enumerate() {
                if b != b'=' || !is_assignment_eq(seg, i) {
                    continue;
                }

                let eq_idx = i;

                // expr start: first non-space after '='
                let mut start = eq_idx + 1;
                while start < seg.len() && is_space(seg[start]) {
                    start += 1;
                }
                if start >= seg.len() {
                    continue;
                }

                // find expr end: next comma/pipe/newline at top level
                let mut paren = 0i32;
                let mut brace = 0i32;
                let mut bracket = 0i32;
                let mut delim = seg.len();

                for j in start..seg.len() {
                    let c = seg[j];
                    match c {
                        b'(' => paren += 1,
                        b')' => paren -= 1,
                        b'{' => brace += 1,
                        b'}' => brace -= 1,
                        b'[' => bracket += 1,
                        b']' => bracket -= 1,
                        b',' | b'|' | b'\n' if paren == 0 && brace == 0 && bracket == 0 => {
                            delim = j;
                            break;
                        }
                        _ => {}
                    }
                }

                if delim <= start {
                    continue;
                }

                // trim trailing spaces before delim
                let mut end = delim;
                while end > start && is_space(seg[end - 1]) {
                    end -= 1;
                }
                if end <= start {
                    continue;
                }

                let expr_bytes = &seg[start..end];
                let expr_str = String::from_utf8(expr_bytes.to_vec()).unwrap_or_default();
                let trimmed = expr_str.trim();

                if trimmed.is_empty() {
                    continue;
                }
                if is_already_parenthesized(trimmed) {
                    continue;
                }
                if is_simple_default_expr(trimmed) {
                    continue;
                }

                // compute byte offsets of `trimmed` inside `seg`
                let leading_ws = expr_str.len() - expr_str.trim_start().len();
                let expr_trim_start = start + leading_ws;
                let expr_trim_end = expr_trim_start + trimmed.len();

                let replacement = format!("({})", trimmed);

                edits.push(TextEdit {
                    start_byte: seg_lo + expr_trim_start,
                    end_byte: seg_lo + expr_trim_end,
                    replacement,
                });
            }
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
