use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

fn is_ident_char(b: u8) -> bool {
    b.is_ascii_alphanumeric() || b == b'_' || b == b'\\'
}

/// Filter out `==`, `<=`, `>=`, `!=`
fn is_assignment_eq(seg: &[u8], idx: usize) -> bool {
    let prev = if idx > 0 { seg[idx - 1] } else { b' ' };
    let next = seg.get(idx + 1).copied().unwrap_or(b' ');
    !(prev == b'=' || prev == b'<' || prev == b'>' || prev == b'!') && next != b'='
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

/// Find `| ... |` header segments that are *actually* pipe param lists:
/// - opening `|` not in string/comment
/// - `{` earlier on the same line
/// - matching closing `|` on the same line, not in string/comment
fn find_pipe_param_headers(buf: &[u8], root: &Node) -> Vec<(usize, usize)> {
    let len = buf.len();
    let mut res = Vec::new();
    let mut i = 0;

    while i < len {
        if buf[i] == b'|' {
            if in_comment_or_string(root, i) {
                i += 1;
                continue;
            }

            // look backwards on this line for '{'
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

            // look forwards on this line for closing '|'
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

/// Given the bytes between `|` and `|` (seg_lo..seg_hi), insert commas between
/// `foo = ... bar = ...` style params that *lack* a comma.
fn fix_header_segment(buf: &[u8], seg_lo: usize, seg_hi: usize, edits: &mut Vec<TextEdit>) {
    let seg = &buf[seg_lo..seg_hi];

    // 1. collect all single '=' positions in this header segment
    let mut eqs: Vec<usize> = Vec::new();
    for (i, &b) in seg.iter().enumerate() {
        if b == b'=' && is_assignment_eq(seg, i) {
            eqs.push(i);
        }
    }
    if eqs.len() < 2 {
        return;
    }

    // 2. for each adjacent pair of assignments, ensure there's a top-level comma
    for win in eqs.windows(2) {
        let e1 = win[0];
        let e2 = win[1];

        // find the *start* of the next param name (just before e2)
        let mut name2_end = e2;
        while name2_end > 0 && is_space(seg[name2_end - 1]) {
            name2_end -= 1;
        }
        if name2_end == 0 {
            continue;
        }

        // scan backwards over identifier chars (including leading '\')
        let mut s = name2_end;
        while s > 0 {
            let c = seg[s - 1];
            if is_ident_char(c) {
                s -= 1;
            } else {
                break;
            }
        }
        let name2_start = s;
        if name2_start <= e1 + 1 {
            // something weird; bail on this pair
            continue;
        }

        // is there already a comma between RHS of first param and the start of the next name?
        let mut paren = 0i32;
        let mut brace = 0i32;
        let mut bracket = 0i32;
        let mut has_comma = false;

        for k in (e1 + 1)..name2_start {
            let c = seg[k];
            match c {
                b'(' => paren += 1,
                b')' => paren -= 1,
                b'{' => brace += 1,
                b'}' => brace -= 1,
                b'[' => bracket += 1,
                b']' => bracket -= 1,
                b',' if paren == 0 && brace == 0 && bracket == 0 => {
                    has_comma = true;
                    break;
                }
                _ => {}
            }
        }

        if has_comma {
            continue;
        }

        // no comma → insert ", " before the second param name.
        // replace any whitespace right before the name, but don't cross newlines.
        let mut ws_start = name2_start;
        while ws_start > 0 {
            let c = seg[ws_start - 1];
            if c == b'\n' {
                break;
            }
            if is_space(c) {
                ws_start -= 1;
            } else {
                break;
            }
        }

        let ins_start = ws_start;
        let ins_end = name2_start;

        edits.push(TextEdit {
            start_byte: seg_lo + ins_start,
            end_byte: seg_lo + ins_end,
            replacement: ", ".to_string(),
        });
    }
}

pub struct PipeParamAddMissingCommas;

impl Rule for PipeParamAddMissingCommas {
    fn name(&self) -> &'static str {
        "pipe_param_missing_commas"
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
            fix_header_segment(buf, seg_lo, seg_hi, &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
