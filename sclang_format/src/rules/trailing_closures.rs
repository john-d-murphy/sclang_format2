use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t' || b == b'\r' || b == b'\n'
}

fn is_ident_char(b: u8) -> bool {
    b.is_ascii_alphanumeric() || b == b'_' || b == b'\\'
}

/// AST-based “are we in a string/comment?”
fn in_comment_or_string(root: &Node, byte: usize) -> bool {
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

/// Try to rewrite an `if(cond, { ... }, { ... })` or `if(cond, { ... })` call at `start_if`.
/// Returns (start_byte, end_byte, replacement) if successful.
fn rewrite_if_call(buf: &[u8], start_if: usize) -> Option<(usize, usize, String)> {
    let len = buf.len();

    // Verify "if" token.
    if start_if + 2 > len {
        return None;
    }
    if &buf[start_if..start_if + 2] != b"if" {
        return None;
    }
    // Ensure it's not part of an identifier.
    if start_if > 0 && is_ident_char(buf[start_if - 1]) {
        return None;
    }
    if start_if + 2 < len && is_ident_char(buf[start_if + 2]) {
        return None;
    }

    // Find '(' after "if".
    let mut i = start_if + 2;
    while i < len && is_space(buf[i]) {
        i += 1;
    }
    if i >= len || buf[i] != b'(' {
        return None;
    }
    let open = i;

    // Scan to matching ')' and record top-level commas.
    let mut paren = 1i32;
    let mut brace = 0i32;
    let mut bracket = 0i32;
    let mut commas: Vec<usize> = Vec::new();
    let mut j = open + 1;
    let mut close_opt = None;

    while j < len {
        let c = buf[j];
        match c {
            b'(' => paren += 1,
            b')' => {
                paren -= 1;
                if paren == 0 {
                    close_opt = Some(j);
                    break;
                }
            }
            b'{' => brace += 1,
            b'}' => brace -= 1,
            b'[' => bracket += 1,
            b']' => bracket -= 1,
            b',' if paren == 1 && brace == 0 && bracket == 0 => {
                commas.push(j);
            }
            _ => {}
        }
        j += 1;
    }

    let close = close_opt?;
    if commas.is_empty() {
        return None; // no arg separation → not the form we want
    }

    // Split condition and arg area.
    let cond_lo = open + 1;
    let cond_hi = commas[0];
    if cond_hi <= cond_lo {
        return None;
    }

    let mut cond_start = cond_lo;
    while cond_start < cond_hi && is_space(buf[cond_start]) {
        cond_start += 1;
    }
    let mut cond_end = cond_hi;
    while cond_end > cond_start && is_space(buf[cond_end - 1]) {
        cond_end -= 1;
    }
    if cond_end <= cond_start {
        return None;
    }
    let cond_str = String::from_utf8_lossy(&buf[cond_start..cond_end]).to_string();

    // Now parse the block arguments after the first comma.
    let mut then_block: Option<(usize, usize)> = None;
    let mut else_block: Option<(usize, usize)> = None;

    // Helper to find a block starting at or after 'idx', returning (start, end_of_block).
    let find_block = |buf: &[u8], mut idx: usize, limit: usize| -> Option<(usize, usize)> {
        while idx < limit && is_space(buf[idx]) {
            idx += 1;
        }
        if idx >= limit || buf[idx] != b'{' {
            return None;
        }
        let start = idx;
        let mut brace = 1i32;
        idx += 1;
        while idx < limit {
            let c = buf[idx];
            match c {
                b'{' => brace += 1,
                b'}' => {
                    brace -= 1;
                    if brace == 0 {
                        return Some((start, idx));
                    }
                }
                _ => {}
            }
            idx += 1;
        }
        None
    };

    let first_arg_lo = commas[0] + 1;
    let arg_region_hi = close;

    if commas.len() == 1 {
        // if(cond, { ... }) form
        if let Some((t_start, t_end)) = find_block(buf, first_arg_lo, arg_region_hi) {
            // ensure only whitespace between end of block and ')'
            let mut k = t_end + 1;
            while k < arg_region_hi {
                if !is_space(buf[k]) {
                    return None;
                }
                k += 1;
            }
            then_block = Some((t_start, t_end));
        } else {
            return None;
        }
    } else if commas.len() >= 2 {
        // if(cond, { ... }, { ... }) form
        if let Some((t_start, t_end)) = find_block(buf, commas[0] + 1, commas[1]) {
            then_block = Some((t_start, t_end));
        } else {
            return None;
        }

        if let Some((e_start, e_end)) = find_block(buf, commas[1] + 1, arg_region_hi) {
            // ensure only whitespace between end of else-block and ')'
            let mut k = e_end + 1;
            while k < arg_region_hi {
                if !is_space(buf[k]) {
                    return None;
                }
                k += 1;
            }
            else_block = Some((e_start, e_end));
        } else {
            return None;
        }
    }

    let (t_start, t_end) = then_block?;
    let then_str = String::from_utf8_lossy(&buf[t_start..=t_end]).to_string();
    let else_str = else_block.map(|(s, e)| String::from_utf8_lossy(&buf[s..=e]).to_string());

    // Build replacement: `if (COND) { ... } [ { ... } ]`
    let mut repl = String::new();
    repl.push_str("if (");
    repl.push_str(cond_str.trim());
    repl.push(')');
    repl.push(' ');
    repl.push_str(&then_str);
    if let Some(es) = else_str {
        repl.push(' ');
        repl.push_str(&es);
    }

    Some((start_if, close + 1, repl))
}

/// Try to rewrite `.do({ ... })` at the given `dot` index (where buf[dot] == '.').
/// Returns (start_byte, end_byte, replacement) for the `( ... )` part.
fn rewrite_do_call(buf: &[u8], dot: usize) -> Option<(usize, usize, String)> {
    let len = buf.len();
    if dot + 3 >= len {
        return None;
    }
    if &buf[dot..dot + 3] != b".do" {
        return None;
    }

    // Skip whitespace after "do"
    let mut i = dot + 3;
    while i < len && is_space(buf[i]) {
        i += 1;
    }
    if i >= len || buf[i] != b'(' {
        return None;
    }
    let open = i;

    // Find matching ')', track nesting and commas.
    let mut paren = 1i32;
    let mut brace = 0i32;
    let mut bracket = 0i32;
    let mut commas = 0usize;
    let mut j = open + 1;
    let mut close_opt = None;

    while j < len {
        let c = buf[j];
        match c {
            b'(' => paren += 1,
            b')' => {
                paren -= 1;
                if paren == 0 {
                    close_opt = Some(j);
                    break;
                }
            }
            b'{' => brace += 1,
            b'}' => brace -= 1,
            b'[' => bracket += 1,
            b']' => bracket -= 1,
            b',' if paren == 1 && brace == 0 && bracket == 0 => {
                commas += 1;
            }
            _ => {}
        }
        j += 1;
    }

    let close = close_opt?;
    if commas > 0 {
        // more than one arg, don't touch
        return None;
    }

    // Inside the parentheses, expect exactly one block argument: { ... }
    let mut k = open + 1;
    while k < close && is_space(buf[k]) {
        k += 1;
    }
    if k >= close || buf[k] != b'{' {
        return None;
    }

    let block_start = k;
    let mut brace_depth = 1i32;
    k += 1;
    let mut block_end_opt = None;
    while k < close {
        let c = buf[k];
        match c {
            b'{' => brace_depth += 1,
            b'}' => {
                brace_depth -= 1;
                if brace_depth == 0 {
                    block_end_opt = Some(k);
                    break;
                }
            }
            _ => {}
        }
        k += 1;
    }

    let block_end = block_end_opt?;
    // After the block and before the closing ')', only whitespace is allowed.
    let mut t = block_end + 1;
    while t < close {
        if !is_space(buf[t]) {
            return None;
        }
        t += 1;
    }

    let block_str = String::from_utf8_lossy(&buf[block_start..=block_end]).to_string();
    let replacement = format!(" {}", block_str);

    Some((open, close + 1, replacement))
}

pub struct TrailingClosures;

impl Rule for TrailingClosures {
    fn name(&self) -> &'static str {
        "trailing_closures"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let buf: &[u8] = &bytes;
        let root = cx.tree.root_node();
        let len = buf.len();

        let mut edits: Vec<TextEdit> = Vec::new();
        let mut i = 0;

        while i < len {
            // First, try `if(...)` form.
            if i + 2 <= len && &buf[i..i + 2] == b"if" && !in_comment_or_string(&root, i) {
                if let Some((start, end, repl)) = rewrite_if_call(buf, i) {
                    edits.push(TextEdit {
                        start_byte: start,
                        end_byte: end,
                        replacement: repl,
                    });
                    // Skip past this call to avoid overlapping edits.
                    i = end;
                    continue;
                }
            }

            // Then, try `.do({ ... })` form.
            if buf[i] == b'.' && !in_comment_or_string(&root, i) {
                if let Some((start, end, repl)) = rewrite_do_call(buf, i) {
                    edits.push(TextEdit {
                        start_byte: start,
                        end_byte: end,
                        replacement: repl,
                    });
                    i = end;
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
