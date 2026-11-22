use anyhow::Result;
use tree_sitter::{Query, QueryCursor, StreamingIterator};

use crate::engine::ast::in_string_or_comment;
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
    fn fix_one(bytes: &[u8], eq: usize, edits: &mut Vec<TextEdit>) {
        // Don't normalize spacing if we have K&R-style block attachment (= {)
        // Skip if right side is just a brace (possibly with whitespace before newline)
        {
            let mut r = eq + 1;
            while r < bytes.len() && (bytes[r] == b' ' || bytes[r] == b'\t') {
                r += 1;
            }
            if r < bytes.len() && bytes[r] == b'{' {
                // This looks like "= {" which is K&R block attachment, don't touch it
                return;
            }
        }

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
        let src_slice: &[u8] = src; // &[u8] for TS & helpers

        let mut edits: Vec<TextEdit> = Vec::new();

        // 1) Use a TS query to capture anonymous '=' tokens anywhere.
        // We'll filter out comparisons and skip strings/comments.
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
            if in_string_or_comment(root, eq) {
                continue;
            }
            // Note: We deliberately do NOT skip pipe parameter lists here.
            // Pipe parameter defaults like |freq=440| need spacing too.

            Self::fix_one(src_slice, eq, &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?; // returns (), we ignore the unit value
        }
        Ok(n)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::engine::IndentStyle;
    use crate::grammar;
    use crate::rules::Rule;

    fn format(src: &str) -> String {
        let mut cx = Ctx::new(
            src.to_string(),
            &grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        AddSpacesAroundAssignment.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_the_character_equals_is_not_an_assignment() {
        assert_eq!(format("x=$=;"), "x = $=;");
        assert_eq!(format("kv = line.split($=);"), "kv = line.split($=);");
    }
}
