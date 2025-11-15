use crate::engine::{Ctx, TextEdit};
use anyhow::Result;
use tree_sitter::StreamingIterator; // <- required in 0.25 to iterate captures
use tree_sitter::{Query, QueryCursor};

pub struct AddSpacesAroundAssignment;

impl AddSpacesAroundAssignment {
    #[inline]
    fn is_assignment_eq(bytes: &[u8], eq: usize) -> bool {
        let len = bytes.len();
        let prev = if eq > 0 { bytes[eq - 1] } else { b' ' };
        let next = if eq + 1 < len { bytes[eq + 1] } else { b' ' };
        // Skip comparison/inequality operators: ==, <=, >=, !=
        if prev == b'=' || next == b'=' || prev == b'<' || prev == b'>' || prev == b'!' {
            return false;
        }
        true
    }

    #[inline]
    fn fix_one(bytes: &[u8], eq: usize, edits: &mut Vec<TextEdit>) {
        // ensure exactly one space BEFORE '=' (not across newline)
        let mut l = eq;
        while l > 0 && bytes[l - 1].is_ascii_whitespace() && bytes[l - 1] != b'\n' {
            l -= 1;
        }
        if l == eq {
            // no space: insert one
            edits.push(TextEdit {
                start_byte: l,
                end_byte: l,
                replacement: " ".to_string(),
            });
        } else {
            // normalize run of spaces to one
            edits.push(TextEdit {
                start_byte: l,
                end_byte: eq,
                replacement: " ".to_string(),
            });
        }

        // ensure exactly one space AFTER '=' unless the next is newline
        let mut r = eq + 1;
        while r < bytes.len() && bytes[r].is_ascii_whitespace() && bytes[r] != b'\n' {
            r += 1;
        }
        if r == eq + 1 {
            // no space after '='
            edits.push(TextEdit {
                start_byte: eq + 1,
                end_byte: eq + 1,
                replacement: " ".to_string(),
            });
        } else {
            // normalize existing whitespace to one space
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
        let src_bytes = cx.bytes(); // Vec<u8>
        let src_slice: &[u8] = src_bytes.as_slice(); // &[u8] for TextProvider + helpers
        let root = cx.tree.root_node();

        let q = Query::new(&cx.tree.language(), r#"("=") @eq"#)?; // needs &Language
        let mut cur = QueryCursor::new();
        let mut caps = cur.captures(&q, root, src_slice); // TextProvider = &[u8]

        let mut edits = Vec::<TextEdit>::new();
        while let Some((m, idx)) = caps.next() {
            let cap = m.captures[*idx]; // <- deref idx
            let eq = cap.node.start_byte();
            if Self::is_assignment_eq(src_slice, eq) {
                // <- pass &[u8]
                Self::fix_one(src_slice, eq, &mut edits); // <- pass &[u8]
            }
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
