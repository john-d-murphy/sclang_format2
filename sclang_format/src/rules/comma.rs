use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use tree_sitter::StreamingIterator;
use tree_sitter::{Query, QueryCursor};

use anyhow::*;

pub struct AddSpacesAfterCommas;

impl Rule for AddSpacesAfterCommas {
    fn name(&self) -> &'static str {
        "AddSpacesAfterCommas"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src_bytes = cx.bytes();
        let len = src_bytes.len();
        let mut edits: Vec<TextEdit> = Vec::new();
        // Build and run the query locally; do not return QueryMatch out of scope.
        let q = Query::new(&cx.tree.language(), r#"( "," ) @comma"#)?;
        let mut cur = QueryCursor::new();
        let mut it = cur.matches(&q, root, src_bytes.as_slice());

        while let Some(m) = it.next() {
            let n = m.captures[0].node;
            let start = n.start_byte();
            let end = n.end_byte();

            // 1) remove spaces/tabs before ','
            if start > 0 {
                let mut j = start;
                while j > 0 && (src_bytes[j - 1] == b' ' || src_bytes[j - 1] == b'\t') {
                    j -= 1;
                }
                if j < start {
                    edits.push(TextEdit {
                        start_byte: j,
                        end_byte: start,
                        replacement: String::new(),
                    });
                }
            }

            // 2) normalize spaces/tabs after ','
            let mut k = end;
            while k < len && (src_bytes[k] == b' ' || src_bytes[k] == b'\t') {
                k += 1;
            }
            let next = if k < len { src_bytes[k] } else { b'\n' };
            let is_delim = matches!(next, b'\n' | b')' | b']' | b'}' | b'|' | b',' | b';');

            if is_delim {
                if k > end {
                    edits.push(TextEdit {
                        start_byte: end,
                        end_byte: k,
                        replacement: String::new(),
                    });
                }
            } else if k == end {
                edits.push(TextEdit {
                    start_byte: end,
                    end_byte: end,
                    replacement: " ".into(),
                });
            } else if k > end + 1 {
                edits.push(TextEdit {
                    start_byte: end,
                    end_byte: k,
                    replacement: " ".into(),
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
