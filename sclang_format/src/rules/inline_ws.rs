use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::{Node, TreeCursor};

pub struct InlineWhitespaceFormat;

impl Rule for InlineWhitespaceFormat {
    fn name(&self) -> &'static str {
        "InlineWhitespaceFormat"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let mut edits = Vec::new();

        // Scope to borrow cx immutably
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

impl InlineWhitespaceFormat {
    fn visit_node(&self, cursor: &mut TreeCursor, cx: &Ctx, edits: &mut Vec<TextEdit>) {
        let node = cursor.node();
        let kind = node.kind();

        // 1. Binary Expressions (e.g., "a + b", "a = b", "a == b")
        if kind == "binary_expression" {
            self.format_binary_op(node, cx, edits);
        }
        // 2. Variable Definitions (e.g., "var x = 10")
        else if kind == "variable_definition" {
            self.format_assignment(node, cx, edits);
        }
        // 3. Arguments (e.g., "arg x = 10")
        // Note: pipe_argument is handled by AddSpacesAroundAssignment
        else if kind == "argument" {
            self.format_assignment(node, cx, edits);
        }

        // Recurse
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

    /// Handles `left OP right`
    fn format_binary_op(&self, node: Node, cx: &Ctx, edits: &mut Vec<TextEdit>) {
        let left = node.child_by_field_name("left");
        let right = node.child_by_field_name("right");
        let op = node.child_by_field_name("operator");

        if let (Some(l), Some(r), Some(o)) = (left, right, op) {
            // Skip method_name operators that are glued to a prefix (like \hello: or .foo:)
            // These should not have space inserted before them
            if o.kind().contains("method_name") {
                let op_start = o.start_byte();
                if op_start > 0 {
                    let src = cx.bytes();
                    let prev = src[op_start - 1];
                    if !prev.is_ascii_whitespace() {
                        return; // Skip \hello: and .foo: patterns
                    }
                }
            }

            // Space between Left and Op
            self.ensure_single_space(cx, l.end_byte(), o.start_byte(), edits);
            // Space between Op and Right
            self.ensure_single_space(cx, o.end_byte(), r.start_byte(), edits);
        }
    }

    /// Handles `name = value` (for vars and args)
    /// Note: The "=" is often an anonymous node, not a named field.
    fn format_assignment(&self, node: Node, cx: &Ctx, edits: &mut Vec<TextEdit>) {
        let name = node.child_by_field_name("name");
        let value = node.child_by_field_name("value");

        if let (Some(n), Some(v)) = (name, value) {
            // We need to find the "=" token between name and value
            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                if child.kind() == "=" {
                    // Space before =
                    self.ensure_single_space(cx, n.end_byte(), child.start_byte(), edits);
                    // Space after =
                    self.ensure_single_space(cx, child.end_byte(), v.start_byte(), edits);
                    break;
                }
            }
        }
    }

    /// Checks the gap between two byte offsets.
    /// - If empty: insert " ".
    /// - If whitespace only (no newlines): replace with " ".
    /// - If contains newline or comments: DO NOTHING (safety).
    fn ensure_single_space(&self, cx: &Ctx, start: usize, end: usize, edits: &mut Vec<TextEdit>) {
        // SAFETY: If the nodes are out of order or overlap (start > end),
        // we cannot format the gap. This can happen with syntax error nodes.
        if start > end {
            return;
        }

        // If there is no gap, insert a space
        if start == end {
            edits.push(TextEdit {
                start_byte: start,
                end_byte: end,
                replacement: " ".to_string(),
            });
            return;
        }

        // Check the text inside the gap
        let gap_text = cx.slice_bytes(start, end);

        // SAFETY: If the gap contains comments or newlines, leave it alone.
        // This rule is "Inline" whitespace only. Line breaking rules handles newlines.
        if gap_text.contains('\n') || gap_text.contains("//") || gap_text.contains("/*") {
            return;
        }

        // If it's already exactly one space, do nothing
        if gap_text == " " {
            return;
        }

        // Otherwise (e.g. "  ", "\t", ""), replace with single space
        edits.push(TextEdit {
            start_byte: start,
            end_byte: end,
            replacement: " ".to_string(),
        });
    }
}
