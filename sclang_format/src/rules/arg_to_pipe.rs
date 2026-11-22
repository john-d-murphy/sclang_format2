// src/rules/arg_to_pipe.rs

use crate::engine::ast::is_literal_default;
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

    /// Whether `node` is an expression in parentheses, `(a + b)` or `(a; b)`:
    /// the one default that is not a literal and stands between pipes as it
    /// is. An event `(a: 1)`, the empty `()` and a series `(1..3)` begin with
    /// a parenthesis too, and are not.
    fn is_parenthesized_expression(node: Node) -> bool {
        let mut cursor = node.walk();
        node.kind() == "code_block"
            && node.named_child_count() > 0
            && node.child_by_field_name("pairs").is_none()
            && !node.children(&mut cursor).any(|child| child.kind() == ",")
    }

    /// One argument as it is written between pipes. What sclang compiles was
    /// asked of sclang: `arg a = X;` is `|a = X|` when X is a literal and
    /// `|a = (X)|` when it is anything else, and the older `arg a(X);` is
    /// `|a = (X)|` whatever X is.
    fn process_argument(&self, arg_node: Node, cx: &Ctx) -> String {
        let Some(name_n) = arg_node.child_by_field_name("name") else {
            return String::new();
        };
        let name = self.get_node_text(cx, name_n);

        let mut cursor = arg_node.walk();
        let Some(default) = arg_node
            .children(&mut cursor)
            .find(|child| child.kind() == "argument_default")
        else {
            return name;
        };
        let Some(value) = default.child_by_field_name("value") else {
            return name;
        };
        let value_text = self.get_node_text(cx, value);

        let older_form = default.child(0).is_some_and(|n| n.kind() == "(");
        if !older_form
            && (is_literal_default(value, cx.bytes()) || Self::is_parenthesized_expression(value))
        {
            format!("{name} = {value_text}")
        } else {
            format!("{name} = ({value_text})")
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
        // The rest argument (`... name`) follows the others after a space, not a comma.
        let mut rest = String::new();
        let mut cursor = param_list.walk();

        for child in param_list.children(&mut cursor) {
            match child.kind() {
                // The whole list is deleted below, and a comment in it would go
                // with it: leave such a list as it is.
                "line_comment" | "block_comment" => return,
                "argument" => {
                    let param_str = self.process_argument(child, cx);
                    if param_str.is_empty() {
                        continue;
                    }
                    if child.child(0).is_some_and(|n| n.kind() == "...") {
                        rest = format!("... {param_str}");
                    } else {
                        params.push(param_str);
                    }
                }
                _ => {}
            }
        }

        let mut params_str = params.join(", ");
        if !rest.is_empty() {
            if !params_str.is_empty() {
                params_str.push(' ');
            }
            params_str.push_str(&rest);
        }
        if params_str.is_empty() {
            return;
        }

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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::engine::IndentStyle;
    use crate::grammar;

    fn format(src: &str) -> String {
        let mut cx = Ctx::new(
            src.to_string(),
            grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        ArgToPipeParams.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_the_rest_argument_keeps_its_dots() {
        assert!(format("f = { arg a, b = 1 ... rest; a };").contains("{ |a, b = 1 ... rest|"));
        assert!(format("g = { arg ...all; all };").contains("{ |... all|"));
    }

    #[test]
    fn test_an_arg_list_with_a_comment_in_it_is_left_alone() {
        let src = "f = {\n    arg freq = 440, // the pitch\n        amp = 0.1;\n    freq * amp\n};";
        assert_eq!(format(src), src);
        let src = "f = { arg freq /* Hz */, amp; freq * amp };";
        assert_eq!(format(src), src);
    }

    /// What sclang compiles each to was asked of sclang: `arg a = X;` is
    /// `|a = X|` for a literal and `|a = (X)|` for anything else, and
    /// `arg a(X);` is `|a = (X)|` whatever X is.
    #[test]
    fn test_a_default_is_parenthesized_unless_it_is_a_literal() {
        for (arg, pipe) in [
            ("a = 1", "a = 1"),
            ("a = -1", "a = -1"),
            ("a = #[1, 2]", "a = #[1, 2]"),
            ("a = inf", "a = inf"),
            ("a = -inf", "a = -inf"),
            ("a = 2pi", "a = 2pi"),
            ("a = $x", "a = $x"),
            ("a = \\q", "a = \\q"),
            ("a = nil", "a = nil"),
            ("a = true", "a = true"),
            ("a = [1, 2]", "a = ([1, 2])"),
            ("a = b", "a = (b)"),
            ("a = thisProcess", "a = (thisProcess)"),
            ("a = Env.perc", "a = (Env.perc)"),
            ("a = 1 + 2", "a = (1 + 2)"),
            ("a = (1 + 2)", "a = (1 + 2)"),
            ("a = (1; 2)", "a = (1; 2)"),
            ("a = (1 + 2).neg", "a = ((1 + 2).neg)"),
            ("a = (b: 1)", "a = ((b: 1))"),
            ("a = ()", "a = (())"),
            ("a = (1..3)", "a = ((1..3))"),
            ("a(3)", "a = (3)"),
            ("a(3 + 1)", "a = (3 + 1)"),
        ] {
            let out = format(&format!("{{ arg {arg}; a }}"));
            assert!(out.contains(&format!("{{ |{pipe}|")), "{arg}: {out}");
        }
    }
}
