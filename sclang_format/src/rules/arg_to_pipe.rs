// src/rules/arg_to_pipe.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::{Node, TreeCursor};

pub struct ArgToPipeParams;

impl Rule for ArgToPipeParams {
    fn name(&self) -> &'static str {
        "arg_to_pipe_params"
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

impl ArgToPipeParams {
    fn get_node_text(&self, cx: &Ctx, node: Node) -> String {
        let start = node.start_byte();
        let end = node.end_byte();
        let bytes = cx.bytes();
        if end > bytes.len() {
            return String::new();
        }
        String::from_utf8_lossy(&bytes[start..end]).to_string()
    }

    fn visit_node(&self, cursor: &mut TreeCursor, cx: &Ctx, edits: &mut Vec<TextEdit>) {
        let node = cursor.node();

        if node.kind() == "function_block" {
            self.process_function_block(node, cx, edits);
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

    /// Check if a node needs parentheses when used as a pipe parameter default
    fn needs_parens(&self, node: Node) -> bool {
        match node.kind() {
            // Method calls need parens: 4.dbamp -> (4.dbamp)
            "function_call" => {
                // Check if it has a receiver (making it a method call)
                let mut cursor = node.walk();
                for child in node.children(&mut cursor) {
                    if child.kind() == "receiver" {
                        return true;
                    }
                }
                false
            }
            // Binary expressions need parens: 1 + 2 -> (1 + 2)
            "binary_expression" => true,
            // Unary expressions might need parens: -1 -> (-1)
            "unary_expression" => true,
            // Code blocks already have braces, no parens needed
            "code_block" => false,
            // Literals, variables, symbols don't need parens
            _ => false,
        }
    }

    fn process_argument(&self, arg_node: Node, cx: &Ctx) -> String {
        let Some(name_n) = arg_node.child_by_field_name("name") else {
            return String::new();
        };

        let name = self.get_node_text(cx, name_n);

        // Find the argument_default child node
        let mut cursor = arg_node.walk();
        let mut default_node: Option<Node> = None;

        for child in arg_node.children(&mut cursor) {
            if child.kind() == "argument_default" {
                default_node = Some(child);
                break;
            }
        }

        let Some(default) = default_node else {
            return name; // No default value
        };

        // Now get the 'value' field from argument_default
        let Some(expr) = default.child_by_field_name("value") else {
            return name;
        };

        let value_text = self.get_node_text(cx, expr);

        if self.needs_parens(expr) {
            let trimmed = value_text.trim();
            if trimmed.starts_with('(') && trimmed.ends_with(')') {
                format!("{} = {}", name, value_text)
            } else {
                format!("{} = ({})", name, value_text)
            }
        } else {
            format!("{} = {}", name, value_text)
        }
    }

    fn process_function_block(&self, block_node: Node, cx: &Ctx, edits: &mut Vec<TextEdit>) {
        // 1. Check if block already has pipe-style parameters
        let mut cursor = block_node.walk();
        let mut has_pipe_params = false;
        for child in block_node.children(&mut cursor) {
            if child.kind() == "parameter_list" {
                // Check if it contains pipe_parameter_list
                let mut inner_cursor = child.walk();
                for inner_child in child.children(&mut inner_cursor) {
                    if inner_child.kind() == "pipe_parameter_list" {
                        has_pipe_params = true;
                        break;
                    }
                }
                if has_pipe_params {
                    return;
                }
            }
        }

        // 2. Find arg-style parameter_list (contains "argument" nodes)
        let mut arg_param_list: Option<Node> = None;
        let mut cursor = block_node.walk();
        for child in block_node.children(&mut cursor) {
            if child.kind() == "parameter_list" {
                // Verify it's arg-style by checking for "argument" children
                let mut inner_cursor = child.walk();
                let mut has_arguments = false;
                for inner_child in child.children(&mut inner_cursor) {
                    if inner_child.kind() == "argument" {
                        has_arguments = true;
                        break;
                    }
                }
                if has_arguments {
                    arg_param_list = Some(child);
                    break;
                }
            }
        }

        let Some(param_list) = arg_param_list else {
            return;
        };

        // 3. Process each argument and build the pipe parameter string
        let mut params = Vec::new();
        let mut cursor = param_list.walk();

        for child in param_list.children(&mut cursor) {
            if child.kind() == "argument" {
                let param_str = self.process_argument(child, cx);
                if !param_str.is_empty() {
                    params.push(param_str);
                }
            }
        }

        if params.is_empty() {
            return;
        }

        let params_str = params.join(", ");

        // 4. Safety check for strings (still want to avoid these)
        if params_str.contains('"') || params_str.contains('\'') {
            return;
        }

        // 5. Find insertion point (after opening brace)
        let block_src = self.get_node_text(cx, block_node);
        let brace_rel = block_src.find('{').unwrap_or(0);
        let insert_pos = block_node.start_byte() + brace_rel + 1;

        let pipe_str = format!(" |{}|", params_str);

        // Delete the entire line containing the parameter_list
        let bytes = cx.bytes();
        let start_byte = param_list.start_byte();
        let mut end_byte = param_list.end_byte();

        // Find start of line (including any leading whitespace)
        let mut line_start = start_byte;
        while line_start > 0 && bytes[line_start - 1] != b'\n' {
            line_start -= 1;
        }

        // Check if everything before param_list on this line is whitespace
        let all_whitespace = bytes[line_start..start_byte]
            .iter()
            .all(|&b| b == b' ' || b == b'\t');

        let delete_start = if all_whitespace {
            line_start
        } else {
            start_byte
        };

        // Only include the newline after the parameter_list if the arg was on its own line.
        // If arg is on the same line as '{', we need to preserve the newline so that
        // subsequent statements (like 'var') stay on their own lines.
        if all_whitespace {
            if end_byte < bytes.len() && bytes[end_byte] == b'\n' {
                end_byte += 1;
            } else if end_byte + 1 < bytes.len()
                && bytes[end_byte] == b'\r'
                && bytes[end_byte + 1] == b'\n'
            {
                end_byte += 2;
            }
        }

        // Create edits
        edits.push(TextEdit {
            start_byte: insert_pos,
            end_byte: insert_pos,
            replacement: pipe_str,
        });

        edits.push(TextEdit {
            start_byte: delete_start,
            end_byte: end_byte,
            replacement: String::new(),
        });
    }
}
