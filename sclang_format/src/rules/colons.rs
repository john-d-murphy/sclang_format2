// src/rules/colons.rs
use crate::engine::ast::end_of_token_before;
use crate::engine::text::is_space;
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::{Node, TreeCursor};

/// One space after the colon of a key.
///
/// A colon that stands apart from its key stays apart, and one that is
/// joined to it stays joined: `(a: 1)` is keyed by the symbol \a and
/// `(a : 1)` by the value of the variable a.
pub struct AddSpacesAroundColons;

impl AddSpacesAroundColons {
    fn visit_node(cursor: &mut TreeCursor, cx: &Ctx, edits: &mut Vec<TextEdit>) {
        let node = cursor.node();

        // Only process colons in associative items (event key:value pairs)
        if node.kind() == "associative_item" {
            Self::process_associative_item(node, cx, edits);
        }

        if cursor.goto_first_child() {
            loop {
                Self::visit_node(cursor, cx, edits);
                if !cursor.goto_next_sibling() {
                    break;
                }
            }
            cursor.goto_parent();
        }
    }

    fn process_associative_item(node: Node, cx: &Ctx, edits: &mut Vec<TextEdit>) {
        let Some(value_node) = node.child_by_field_name("value") else {
            return;
        };
        // The colon is the last character of an event_key, and a token of its
        // own after any other key.
        let mut cursor = node.walk();
        let Some(colon) = node
            .children(&mut cursor)
            .find(|child| matches!(child.kind(), "event_key" | ":"))
        else {
            return;
        };
        let src = cx.bytes();
        // Blanks before a colon that stands apart come down to one. They are
        // never removed: without them a name and its colon are one token.
        let key_end = end_of_token_before(colon);
        let blanks = &src[key_end..colon.start_byte()];
        if colon.kind() == ":" && blanks.len() > 1 && blanks.iter().all(|&b| is_space(b)) {
            edits.push(TextEdit {
                start_byte: key_end,
                end_byte: colon.start_byte(),
                replacement: " ".to_string(),
            });
        }
        Self::fix_space_after_colon(src, colon.end_byte(), value_node.start_byte(), edits);
    }

    fn fix_space_after_colon(
        bytes: &[u8],
        start: usize,
        value_start: usize,
        edits: &mut Vec<TextEdit>,
    ) {
        // Check for newlines - if multiline, don't touch
        if bytes[start..value_start]
            .iter()
            .any(|&b| b == b'\n' || b == b'\r')
        {
            return;
        }

        let whitespace_count = value_start - start;

        if whitespace_count == 0 {
            // No space after colon - insert one
            edits.push(TextEdit {
                start_byte: start,
                end_byte: start,
                replacement: " ".to_string(),
            });
        } else if whitespace_count != 1 {
            // Wrong amount of whitespace - replace with exactly one space
            edits.push(TextEdit {
                start_byte: start,
                end_byte: value_start,
                replacement: " ".to_string(),
            });
        }
        // If whitespace_count == 1, it's already correct
    }
}

impl Rule for AddSpacesAroundColons {
    fn name(&self) -> &'static str {
        "spaces_around_colons"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        if cx.tree.root_node().has_error() {
            return Ok(0);
        }

        let mut edits = Vec::new();

        {
            let root = cx.tree.root_node();
            let mut cursor = root.walk();
            Self::visit_node(&mut cursor, cx, &mut edits);
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

    fn format(src: &str) -> String {
        let mut cx = Ctx::new(
            src.to_string(),
            &grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        AddSpacesAroundColons.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_one_space_after_a_colon() {
        assert_eq!(format("(a:1, \\b:  2, \"c\":3, 4:5)"), "(a: 1, \\b: 2, \"c\": 3, 4: 5)");
        assert_eq!(format("[a:1, b: 2]"), "[a: 1, b: 2]");
    }

    /// Asked of sclang: `(a : 1)` and `(a: 1)` compile to different things,
    /// and so do `[a : 1]` and `[a: 1]`, `(Object : 1)` and `(Object: 1)`.
    #[test]
    fn test_the_space_before_a_colon_is_kept() {
        for src in ["(a : 1)", "[a : 1]", "(Object : 1)", "(a + 1 : 2)", "(\\a : 1)"] {
            assert_eq!(format(src), src);
        }
        assert_eq!(format("(a :1)"), "(a : 1)");
        assert_eq!(format("(pan  \t:  -0.5)"), "(pan : -0.5)");
        assert_eq!(format("(a; \"b:c\" :1)"), "(a; \"b:c\" : 1)");
    }
}
