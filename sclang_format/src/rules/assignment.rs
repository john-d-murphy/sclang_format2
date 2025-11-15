use anyhow::Result;
use std::collections::HashSet;
use tree_sitter::{Node, Query, QueryCursor, StreamingIterator};

use crate::engine::{Ctx, TextEdit};

pub struct AddSpacesAroundAssignment;

impl AddSpacesAroundAssignment {
    #[inline]
    fn is_assignment_eq(bytes: &[u8], eq: usize) -> bool {
        // not '==', '>=', '<=', '!='
        let prev = bytes.get(eq.wrapping_sub(1)).copied().unwrap_or_default();
        let next = bytes.get(eq + 1).copied().unwrap_or_default();
        !(prev == b'=' || next == b'=' || prev == b'<' || prev == b'>' || prev == b'!')
    }

    #[inline]
    fn in_comment_or_string(root: Node, byte: usize) -> bool {
        let mut cur = root.descendant_for_byte_range(byte, byte + 1);
        while let Some(n) = cur {
            match n.kind() {
                // conservative skip list; extend if your grammar uses different names
                "comment" | "block_comment" | "line_comment" | "string" => return true,
                _ => {}
            }
            cur = n.parent();
        }
        false
    }

    #[inline]
    fn fix_one(bytes: &[u8], eq: usize, edits: &mut Vec<TextEdit>) {
        // normalize to exactly one ASCII space around '=' without crossing newlines
        // left side
        let mut l = eq;
        while l > 0 && bytes[l - 1].is_ascii_whitespace() && bytes[l - 1] != b'\n' {
            l -= 1;
        }
        if l == eq {
            // insert one space before '='
            edits.push(TextEdit {
                start_byte: l,
                end_byte: l,
                replacement: " ".to_string(),
            });
        } else if eq - l != 1 {
            // compress run to a single space
            edits.push(TextEdit {
                start_byte: l,
                end_byte: eq,
                replacement: " ".to_string(),
            });
        }

        // right side
        let mut r = eq + 1;
        while r < bytes.len() && bytes[r].is_ascii_whitespace() && bytes[r] != b'\n' {
            r += 1;
        }
        if r == eq + 1 {
            // insert one space after '='
            edits.push(TextEdit {
                start_byte: r,
                end_byte: r,
                replacement: " ".to_string(),
            });
        } else if r - (eq + 1) != 1 {
            // compress run to a single space
            edits.push(TextEdit {
                start_byte: eq + 1,
                end_byte: r,
                replacement: " ".to_string(),
            });
        }
    }
}

impl crate::rules::Rule for AddSpacesAroundAssignment {
    fn name(&self) -> &'static str {
        "spaces_around_assignment"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src = cx.bytes(); // Vec<u8>
        let src_slice: &[u8] = src.as_slice(); // &[u8] for TS & helpers

        let mut edits: Vec<TextEdit> = Vec::new();
        let mut seen_eq: HashSet<usize> = HashSet::new();

        // 1) Use a TS query to capture anonymous '=' tokens anywhere.
        //    We'll filter out comparisons and skip strings/comments.
        let lang = cx.tree.language();
        let q = Query::new(&lang, r#"("=") @eq"#)?;
        let mut cur = QueryCursor::new();
        let mut caps = cur.captures(&q, root, src_slice);

        while let Some((m, idx)) = caps.next() {
            let cap = m.captures[*idx]; // idx is &usize in 0.25 streaming iterator
            let eq = cap.node.start_byte();

            if !Self::is_assignment_eq(src_slice, eq) {
                continue;
            }
            if Self::in_comment_or_string(root, eq) {
                continue;
            }

            Self::fix_one(src_slice, eq, &mut edits);
            seen_eq.insert(eq);
        }

        // 2) Fallback scan for any '=' the query didn’t yield (robust across grammar quirks).
        for (i, &b) in src_slice.iter().enumerate() {
            if b != b'=' || seen_eq.contains(&i) {
                continue;
            }
            if !Self::is_assignment_eq(src_slice, i) {
                continue;
            }
            if Self::in_comment_or_string(root, i) {
                continue;
            }
            Self::fix_one(src_slice, i, &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?; // returns (), we ignore the unit value
        }
        Ok(n)
    }
}
