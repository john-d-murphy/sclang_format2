// src/rules/pipe_param_commas.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

pub struct PipeParamAddMissingCommas;

impl Rule for PipeParamAddMissingCommas {
    fn name(&self) -> &'static str {
        "pipe_param_missing_commas"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src = cx.bytes();

        let mut edits = Vec::new();

        // Handle pipe-style with AST (works when commas are missing)
        walk_tree_for_pipes(root, &src, &mut edits);

        // Handle arg-style with byte scanning (AST is broken when commas are missing)
        fix_arg_style_params(&src, &root, &mut edits);

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

fn walk_tree_for_pipes(node: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    if node.kind() == "pipe_parameter_list" {
        fix_missing_commas_in_pipe_list(node, src, edits);
    }

    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        walk_tree_for_pipes(child, src, edits);
    }
}

/// Check if a node needs parentheses when used as a pipe parameter default
fn needs_parens(node: Node) -> bool {
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

fn get_node_text(src: &[u8], node: Node) -> String {
    let start = node.start_byte();
    let end = node.end_byte();
    if end > src.len() {
        return String::new();
    }
    String::from_utf8_lossy(&src[start..end]).to_string()
}

fn fix_missing_commas_in_pipe_list(pipe_list: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    let mut args = Vec::new();
    let mut cursor = pipe_list.walk();

    if cursor.goto_first_child() {
        loop {
            let child = cursor.node();
            if child.kind() == "pipe_argument" {
                args.push(child);
            }
            if !cursor.goto_next_sibling() {
                break;
            }
        }
    }

    if args.len() < 2 {
        return;
    }

    // First pass: add missing commas
    for window in args.windows(2) {
        let arg1 = window[0];
        let arg2 = window[1];

        let between_start = arg1.end_byte();
        let between_end = arg2.start_byte();

        if between_start >= between_end {
            continue;
        }

        let between = &src[between_start..between_end];
        let has_comma = between.iter().any(|&b| b == b',');

        if !has_comma {
            edits.push(TextEdit {
                start_byte: between_start,
                end_byte: between_end,
                replacement: ", ".to_string(),
            });
        }
    }

    // Second pass: wrap values in parens if needed
    for arg in args {
        wrap_value_if_needed(arg, src, edits);
    }
}

fn wrap_value_if_needed(pipe_arg: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    // Find the value node within this pipe_argument
    let mut cursor = pipe_arg.walk();
    let mut value_node: Option<Node> = None;

    for child in pipe_arg.children(&mut cursor) {
        if child.kind() == "value" {
            // The 'value' field wraps the actual expression
            let mut value_cursor = child.walk();
            for value_child in child.children(&mut value_cursor) {
                value_node = Some(value_child);
                break;
            }
            break;
        }
    }

    let Some(value) = value_node else {
        return; // No default value
    };

    if !needs_parens(value) {
        return; // Doesn't need wrapping
    }

    let value_text = get_node_text(src, value);
    let trimmed = value_text.trim();

    // Check if already wrapped in parens
    if trimmed.starts_with('(') && trimmed.ends_with(')') {
        return; // Already has parens
    }

    // Wrap in parentheses
    edits.push(TextEdit {
        start_byte: value.start_byte(),
        end_byte: value.start_byte(),
        replacement: "(".to_string(),
    });

    edits.push(TextEdit {
        start_byte: value.end_byte(),
        end_byte: value.end_byte(),
        replacement: ")".to_string(),
    });
}

fn fix_arg_style_params(src: &[u8], root: &Node, edits: &mut Vec<TextEdit>) {
    let len = src.len();
    let mut i = 0;

    while i < len {
        // Look for "arg " keyword
        if i + 4 <= len
            && &src[i..i + 3] == b"arg"
            && (src[i + 3] == b' ' || src[i + 3] == b'\t' || src[i + 3] == b'\n')
        {
            if in_comment_or_string(root, i) {
                i += 1;
                continue;
            }

            // Find the semicolon that ends this arg list
            let mut j = i + 4;
            while j < len && src[j] != b';' {
                j += 1;
            }

            if j < len {
                // Process the arg list from i+4 to j
                fix_arg_list_segment(src, i + 4, j, edits);
            }

            i = j + 1;
        } else {
            i += 1;
        }
    }
}

fn fix_arg_list_segment(src: &[u8], start: usize, end: usize, edits: &mut Vec<TextEdit>) {
    let seg = &src[start..end];

    // Find all '=' positions (assignments)
    let mut eqs = Vec::new();
    for (i, &b) in seg.iter().enumerate() {
        if b == b'=' && is_assignment_eq(seg, i) {
            eqs.push(i);
        }
    }

    if eqs.len() < 2 {
        return;
    }

    // Between each pair of assignments, ensure there's a comma
    for win in eqs.windows(2) {
        let e1 = win[0];
        let e2 = win[1];

        // Find start of next param name (before e2)
        let mut name2_end = e2;
        while name2_end > 0 && is_space(seg[name2_end - 1]) {
            name2_end -= 1;
        }
        if name2_end == 0 {
            continue;
        }

        let mut name2_start = name2_end;
        while name2_start > 0 {
            let c = seg[name2_start - 1];
            if is_ident_char(c) {
                name2_start -= 1;
            } else {
                break;
            }
        }

        if name2_start <= e1 + 1 {
            continue;
        }

        // Check for comma between e1+1 and name2_start
        let mut paren = 0i32;
        let mut brace = 0i32;
        let mut bracket = 0i32;
        let mut has_comma = false;

        for k in (e1 + 1)..name2_start {
            let c = seg[k];
            match c {
                b'(' => paren += 1,
                b')' => paren -= 1,
                b'{' => brace += 1,
                b'}' => brace -= 1,
                b'[' => bracket += 1,
                b']' => bracket -= 1,
                b',' if paren == 0 && brace == 0 && bracket == 0 => {
                    has_comma = true;
                    break;
                }
                _ => {}
            }
        }

        if !has_comma {
            let mut ws_start = name2_start;
            while ws_start > 0 && is_space(seg[ws_start - 1]) {
                ws_start -= 1;
            }

            edits.push(TextEdit {
                start_byte: start + ws_start,
                end_byte: start + name2_start,
                replacement: ", ".to_string(),
            });
        }
    }
}

const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t' || b == b'\n'
}

const fn is_ident_char(b: u8) -> bool {
    b.is_ascii_alphanumeric() || b == b'_' || b == b'\\'
}

fn is_assignment_eq(seg: &[u8], idx: usize) -> bool {
    let prev = if idx > 0 { seg[idx - 1] } else { b' ' };
    let next = seg.get(idx + 1).copied().unwrap_or(b' ');
    !(prev == b'=' || prev == b'<' || prev == b'>' || prev == b'!') && next != b'='
}

fn in_comment_or_string(root: &Node, byte: usize) -> bool {
    let mut cur = root.descendant_for_byte_range(byte, byte + 1);
    while let Some(n) = cur {
        match n.kind() {
            "comment" | "block_comment" | "line_comment" | "string" => return true,
            _ => {}
        }
        cur = n.parent();
    }
    false
}
