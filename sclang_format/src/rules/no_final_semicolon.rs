use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

pub struct NoFinalSemicolon;

impl Rule for NoFinalSemicolon {
    fn name(&self) -> &'static str {
        "NoFinalSemicolon"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src = cx.bytes();
        let mut edits = Vec::new();
        walk_blocks(root, &src, &mut edits);
        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

fn walk_blocks(node: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    // Process function_block nodes (not "block"!)
    if node.kind() == "function_block" {
        process_block(node, src, edits);
    }
    // Recursively walk children
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        walk_blocks(child, src, edits);
    }
}

fn process_block(node: Node, _src: &[u8], edits: &mut Vec<TextEdit>) {
    let mut last_expr: Option<Node> = None;
    let mut last_expr_end: usize = 0;
    let mut semicolons: Vec<(usize, usize)> = Vec::new();
    let mut cursor = node.walk();

    // Single pass: collect last expression and all semicolons
    for child in node.children(&mut cursor) {
        let kind = child.kind();

        // Track expression nodes - must include ALL possible statement types
        if matches!(
            kind,
            "function_call"
                | "binary_expression"
                | "unary_expression"
                | "literal"
                | "variable"
                | "collection"
                | "control_structure"
                | "variable_definition"
                | "variable_definition_sequence"
                | "indexed_collection"
                | "code_block"
                | "function_block"
                | "event"
                | "comprehension"
                | "ref_expression"
                | "duplicated_statement"  // x ! 2
                | "class"
                | "method_call"
                | "while"
        ) {
            last_expr = Some(child);
            last_expr_end = child.end_byte();
        }
        // Track all semicolons
        else if kind == ";" {
            semicolons.push((child.start_byte(), child.end_byte()));
        }
    }

    // Now find and remove the semicolon that comes right after the last expression
    if last_expr.is_some() {
        for (semi_start, semi_end) in semicolons {
            if semi_start >= last_expr_end {
                edits.push(TextEdit {
                    start_byte: semi_start,
                    end_byte: semi_end,
                    replacement: String::new(),
                });
                break; // Only remove the first semicolon after the last expression
            }
        }
    }
}
