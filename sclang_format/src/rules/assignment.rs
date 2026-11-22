use anyhow::Result;
use tree_sitter::Node;

use crate::engine::ast::{blanks_before, tokens_of_kinds};
use crate::engine::{Ctx, TextEdit};

/// One space on each side of the `=` of an assignment or a default.
pub struct AddSpacesAroundAssignment;

impl AddSpacesAroundAssignment {
    #[inline]
    fn fix_one(bytes: &[u8], equals: Node, edits: &mut Vec<TextEdit>) {
        let eq = equals.start_byte();
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
        // The blanks before it, no further back than the token before:
        // the second byte of a character is no space.
        let l = blanks_before(bytes, equals);
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
        let bytes = cx.bytes();
        let mut edits = Vec::new();
        // Every `=` token: `==`, `>=` and the like are tokens of their own,
        // and a `=` in a string, a character or a comment is none.
        // Pipe parameter defaults like |freq=440| need spacing too.
        for equals in tokens_of_kinds(cx.tree.root_node(), &["="]) {
            Self::fix_one(bytes, equals, &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
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
