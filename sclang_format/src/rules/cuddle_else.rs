// src/rules/cuddle_else.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::{Node, TreeCursor};

pub struct CuddleElse;

impl Rule for CuddleElse {
    fn name(&self) -> &'static str {
        "cuddle_else"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let mut edits = Vec::new();

        // BLOCK 1: READ-ONLY PHASE
        // We wrap this in a block to limit the lifetime of the borrow.
        // The cursor and root borrowing 'cx' will die at the end of this block.
        {
            let root = cx.tree.root_node();
            let mut cursor = root.walk();
            // Pass 'cx' as an immutable reference here
            self.visit_node(&mut cursor, cx, &mut edits);
        } // <--- Cursor dies here, releasing the borrow on cx

        // BLOCK 2: WRITE PHASE
        // Now cx is free to be borrowed mutably
        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

impl CuddleElse {
    fn visit_node(&self, cursor: &mut TreeCursor, cx: &Ctx, edits: &mut Vec<TextEdit>) {
        let node = cursor.node();
        let buf = cx.bytes(); // This likely returns Vec<u8> or &Vec<u8>

        if node.kind() == "if" {
            // FIX 1: Pass '&buf' instead of 'buf' to convert Vec to slice
            self.cuddle_if_branches(node, &buf, edits);
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

    fn cuddle_if_branches(&self, node: Node, buf: &[u8], edits: &mut Vec<TextEdit>) {
        let true_branch = node.child_by_field_name("true");
        let false_branch = node.child_by_field_name("false");

        if let (Some(t_node), Some(f_node)) = (true_branch, false_branch) {
            let start_byte = t_node.end_byte();
            let end_byte = f_node.start_byte();

            if start_byte >= end_byte {
                return;
            }

            let gap_slice = &buf[start_byte..end_byte];

            let is_pure_whitespace = gap_slice
                .iter()
                .all(|b| *b == b' ' || *b == b'\t' || *b == b'\n' || *b == b'\r');

            let has_newline = gap_slice.contains(&b'\n');

            if is_pure_whitespace && has_newline {
                edits.push(TextEdit {
                    start_byte,
                    end_byte,
                    replacement: " ".to_string(),
                });
            }
        }
    }
}
