// src/rules/binary_ops.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

/// Binary operators we normalize.
/// We handle:
//  - single-char: + - * / % < >
//  - double-char: == != <= >= && ||
const SINGLE_OPS: &[u8] = b"+-*/%<>!";
const DOUBLE_OPS: &[&[u8]] = &[b"==", b"!=", b"<=", b">=", b"&&", b"||"];

const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

const fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
}

const fn is_ascii_op_char(b: u8) -> bool {
    matches!(
        b,
        b'+' | b'-' | b'*' | b'/' | b'%' | b'<' | b'>' | b'=' | b'&' | b'|' | b'!'
    )
}

/// Super-cautious check: are we inside a comment or string at `byte`?
fn in_comment_or_string(root: Node, byte: usize) -> bool {
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

fn is_unary_plus_minus(bytes: &[u8], i: usize) -> bool {
    let c = bytes[i];
    if c != b'+' && c != b'-' {
        return false;
    }

    // Look left for the first non-space, non-newline char.
    let mut j = i;
    while j > 0 {
        j -= 1;
        let b = bytes[j];
        if is_space(b) || is_newline(b) {
            continue;
        }
        // If previous is one of these, treat + / - as unary:
        // beginning of expression, opening delimiters, comma, semicolon,
        // **colon**, another operator, or '='.
        if matches!(b, b'(' | b'[' | b'{' | b',' | b';' | b':') || is_ascii_op_char(b) || b == b'='
        {
            return true;
        }
        // Otherwise, treat as binary.
        return false;
    }

    // No previous non-space char: start of file/line -> unary
    true
}

/// Decide if a `!` at index `i` is *likely* unary (logical not).
/// We mirror the heuristic for + / -.
fn is_unary_bang(bytes: &[u8], i: usize) -> bool {
    let c = bytes[i];
    if c != b'!' {
        return false;
    }

    // Look left for the first non-space, non-newline char.
    let mut j = i;
    while j > 0 {
        j -= 1;
        let b = bytes[j];
        if is_space(b) || is_newline(b) {
            continue;
        }
        // If previous is one of these, treat `!` as unary:
        // beginning of expression, opening delimiters, comma, semicolon,
        // another operator, or '='.
        if matches!(b, b'(' | b'[' | b'{' | b',' | b';') || is_ascii_op_char(b) || b == b'=' {
            return true;
        }
        // Otherwise, treat as binary.
        return false;
    }

    // No previous non-space char: start of file/line -> unary
    true
}

/// Normalize spaces around binary operators.
pub struct AddSpacesAroundBinaryOps;

impl Rule for AddSpacesAroundBinaryOps {
    fn name(&self) -> &'static str {
        "spaces_around_binary_ops"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src = cx.bytes();
        let len = src.len();
        let bytes: &[u8] = &src;

        let mut edits: Vec<TextEdit> = Vec::new();
        let mut i = 0usize;

        while i < len {
            let b = bytes[i];

            // Skip if in comment/string.
            if in_comment_or_string(root, i) {
                i += 1;
                continue;
            }

            // Handle double-char operators first.
            let mut handled_double = false;
            if i + 1 < len {
                let pair = &bytes[i..i + 2];
                for op in DOUBLE_OPS {
                    if pair == *op {
                        fix_around_op(bytes, i, 2, &mut edits);
                        i += 2;
                        handled_double = true;
                        break;
                    }
                }
            }
            if handled_double {
                continue;
            }

            // Single-char operators.
            if SINGLE_OPS.contains(&b) {
                // Unary + / - are skipped.
                if (b == b'+' || b == b'-') && is_unary_plus_minus(bytes, i) {
                    i += 1;
                    continue;
                }

                // Unary ! (logical not) is also skipped.
                if b == b'!' && is_unary_bang(bytes, i) {
                    i += 1;
                    continue;
                }

                fix_around_op(bytes, i, 1, &mut edits);
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

/// Normalize spaces around an operator starting at `op_start` of length `op_len`.
///
/// Ensures exactly one ASCII space before and after, without crossing newlines.
fn fix_around_op(bytes: &[u8], op_start: usize, op_len: usize, edits: &mut Vec<TextEdit>) {
    let len = bytes.len();
    let op_end = op_start + op_len;

    // ----- left side -----
    let mut l = op_start;
    while l > 0 && bytes[l - 1].is_ascii_whitespace() && !is_newline(bytes[l - 1]) {
        l -= 1;
    }
    if l == op_start {
        // insert one space before op
        edits.push(TextEdit {
            start_byte: l,
            end_byte: l,
            replacement: " ".to_string(),
        });
    } else if op_start - l != 1 {
        // compress whitespace run to one space
        edits.push(TextEdit {
            start_byte: l,
            end_byte: op_start,
            replacement: " ".to_string(),
        });
    }

    // ----- right side -----
    let mut r = op_end;
    while r < len && bytes[r].is_ascii_whitespace() && !is_newline(bytes[r]) {
        r += 1;
    }
    if r == op_end {
        // insert one space after op
        edits.push(TextEdit {
            start_byte: r,
            end_byte: r,
            replacement: " ".to_string(),
        });
    } else if r - op_end != 1 {
        // compress whitespace run to one space
        edits.push(TextEdit {
            start_byte: op_end,
            end_byte: r,
            replacement: " ".to_string(),
        });
    }
}
