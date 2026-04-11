// src/rules/colons.rs
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::{Node, TreeCursor};

fn is_identifier_char(b: u8) -> bool {
    (b'a'..=b'z').contains(&b)
        || (b'A'..=b'Z').contains(&b)
        || (b'0'..=b'9').contains(&b)
        || b == b'_'
}

pub struct AddSpacesAroundColons;

impl AddSpacesAroundColons {
    fn visit_node(&self, cursor: &mut TreeCursor, cx: &Ctx, edits: &mut Vec<TextEdit>) {
        let node = cursor.node();

        // Only process colons in associative items (event key:value pairs)
        if node.kind() == "associative_item" {
            self.process_associative_item(node, cx, edits);
        }

        if cursor.goto_first_child() {
            loop {
                self.visit_node(cursor, cx, edits);
                if !cursor.goto_next_sibling() {
                    break;
                }
            }
            cursor.goto_parent();
        }
    }

    fn process_associative_item(&self, node: Node, cx: &Ctx, edits: &mut Vec<TextEdit>) {
        let Some(key_node) = node.child_by_field_name("key") else {
            return;
        };
        let Some(value_node) = node.child_by_field_name("value") else {
            return;
        };

        let src = cx.bytes();

        // For event_key tokens, the colon is INSIDE the key token
        // e.g., "freq:" or "amp :" - we need to normalize to "key:" (no space before colon)
        if key_node.kind() == "event_key" {
            let key_start = key_node.start_byte();
            let key_end = key_node.end_byte();
            let key_text = &src[key_start..key_end];

            // Find where identifier ends (first non-ident char)
            let ident_end = key_text
                .iter()
                .position(|&b| !is_identifier_char(b))
                .unwrap_or(key_text.len());

            // Find the colon position within the key token
            if let Some(colon_offset) = key_text.iter().rposition(|&b| b == b':') {
                let abs_ident_end = key_start + ident_end;
                let abs_colon = key_start + colon_offset;

                // Remove any whitespace between identifier and colon
                if abs_ident_end < abs_colon {
                    edits.push(TextEdit {
                        start_byte: abs_ident_end,
                        end_byte: abs_colon,
                        replacement: String::new(),
                    });
                }
            }
        }

        // Fix spacing AFTER the key (before value)
        // The key token ends after the colon, so we check from key_end to value_start
        let after_key = key_node.end_byte();
        let value_start = value_node.start_byte();

        self.fix_space_after_colon(&src, after_key, value_start, edits);
    }

    fn fix_space_after_colon(
        &self,
        bytes: &[u8],
        start: usize,
        value_start: usize,
        edits: &mut Vec<TextEdit>,
    ) {
        // Check for newlines - if multiline, don't touch
        for i in start..value_start {
            if bytes[i] == b'\n' || bytes[i] == b'\r' {
                return;
            }
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
        let mut edits = Vec::new();

        {
            let root = cx.tree.root_node();
            let mut cursor = root.walk();
            self.visit_node(&mut cursor, cx, &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}
