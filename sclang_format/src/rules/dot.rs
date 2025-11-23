use anyhow::Result;
use tree_sitter::{Node, Query, QueryCursor, StreamingIterator};

use crate::engine::{Ctx, TextEdit};

pub struct NoSpacesAroundDot;

impl NoSpacesAroundDot {
    #[inline]
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

    #[inline]
    fn is_dot_at_line_start(src: &[u8], dot_pos: usize) -> bool {
        // Check if there's only whitespace (not newlines) before the dot since the last newline
        let mut i = dot_pos;
        while i > 0 && src[i - 1] != b'\n' && src[i - 1] != b'\r' {
            if !src[i - 1].is_ascii_whitespace() {
                return false;
            }
            i -= 1;
        }
        // If we got here, only whitespace exists before dot since last newline → dot is at line start
        true
    }
}

impl crate::rules::Rule for NoSpacesAroundDot {
    fn name(&self) -> &'static str {
        "no_spaces_around_dot"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let bytes = cx.bytes();
        let src = bytes.as_slice();

        let mut edits = Vec::<TextEdit>::new();

        // Capture the '.' token inside a method_call
        let q = Query::new(&cx.tree.language(), r#"(method_call "." @dot)"#)?;
        let mut cur = QueryCursor::new();
        let mut caps = cur.captures(&q, root, src);

        while let Some((m, idx)) = caps.next() {
            let cap = m.captures[*idx];
            let dot = cap.node.start_byte();
            if Self::in_comment_or_string(root, dot) {
                continue;
            }

            // Skip dots that are at the start of a line (already in desired format by dot_chain_layout)
            if Self::is_dot_at_line_start(src, dot) {
                continue;
            }

            // strip spaces before/after '.' (but never cross newlines)
            // left
            let mut l = dot;
            while l > 0 && src[l - 1].is_ascii_whitespace() && src[l - 1] != b'\n' {
                l -= 1;
            }
            if l != dot {
                edits.push(TextEdit {
                    start_byte: l,
                    end_byte: dot,
                    replacement: String::new(),
                });
            }
            // right
            let mut r = dot + 1;
            while r < src.len() && src[r].is_ascii_whitespace() && src[r] != b'\n' {
                r += 1;
            }
            if r != dot + 1 {
                edits.push(TextEdit {
                    start_byte: dot + 1,
                    end_byte: r,
                    replacement: String::new(),
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
