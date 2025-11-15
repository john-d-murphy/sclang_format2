use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::*;
use tree_sitter::{Query, QueryCursor, StreamingIterator};

pub struct AddSpacesAroundAssignment;

impl Rule for AddSpacesAroundAssignment {
    fn name(&self) -> &'static str {
        "AddSpacesAroundAssignment"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src = cx.bytes();
        let len = src.len();
        let mut edits: Vec<TextEdit> = Vec::new();

        // capture the lone '=' token; we'll filter out ==, <=, >=, != in Rust
        let q = Query::new(&cx.tree.language(), r#"( "=" ) @eq"#)?;
        let mut cur = QueryCursor::new();
        let mut it = cur.matches(&q, root, src.as_slice());

        while let Some(m) = it.next() {
            let n = m.captures[0].node;
            let start = n.start_byte();
            let end = n.end_byte();

            // Protect compound operators: ==, <=, >=, !=
            let prev = if start > 0 { src[start - 1] } else { b'\n' };
            let next = if end < len { src[end] } else { b'\n' };
            let is_compound =
                prev == b'=' || prev == b'!' || prev == b'<' || prev == b'>' || next == b'=';
            if is_compound {
                continue;
            }

            // left side: exactly one space unless touching newline or opener
            // (don’t cross newlines; don’t add space before start-of-line)
            let mut l = start;
            while l > 0 && (src[l - 1] == b' ' || src[l - 1] == b'\t') {
                l -= 1;
            }
            let left_newline = l > 0 && src[l - 1] == b'\n';
            let left_opener = l > 0 && matches!(src[l - 1], b'(' | b'[' | b'{' | b'|');
            if !left_newline && !left_opener {
                let want = " ";
                let have = &src[l..start];
                if have != want.as_bytes() {
                    edits.push(TextEdit {
                        start_byte: l,
                        end_byte: start,
                        replacement: " ".into(),
                    });
                }
            } else {
                // remove any existing left spaces
                if l < start {
                    edits.push(TextEdit {
                        start_byte: l,
                        end_byte: start,
                        replacement: String::new(),
                    });
                }
            }

            // right side: exactly one space unless followed by newline or closer/delims
            let mut r = end;
            while r < len && (src[r] == b' ' || src[r] == b'\t') {
                r += 1;
            }
            let right_newline = r < len && src[r] == b'\n';
            let right_delim = r < len && matches!(src[r], b')' | b']' | b'}' | b'|' | b',' | b';');
            if !right_newline && !right_delim {
                if r == end {
                    edits.push(TextEdit {
                        start_byte: end,
                        end_byte: end,
                        replacement: " ".into(),
                    });
                } else if r > end + 1 {
                    edits.push(TextEdit {
                        start_byte: end,
                        end_byte: r,
                        replacement: " ".into(),
                    });
                }
            } else {
                if r > end {
                    edits.push(TextEdit {
                        start_byte: end,
                        end_byte: r,
                        replacement: String::new(),
                    });
                }
            }
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
