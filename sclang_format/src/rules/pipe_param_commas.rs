use crate::engine::ast::in_string_or_comment;
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
        walk_tree_for_pipes(root, src, &mut edits);

        // Handle arg-style with byte scanning (AST is broken when commas are
        // missing). Only then: text that parsed has every comma it needs.
        if root.has_error() {
            fix_arg_style_params(src, &root, &mut edits);
        }

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

    for window in args.windows(2) {
        let (before, after) = (window[0], window[1]);

        let between_start = before.end_byte();
        let between_end = after.start_byte();

        if between_start >= between_end {
            continue;
        }

        let between = &src[between_start..between_end];
        let has_comma = between.contains(&b',');

        if !has_comma {
            edits.push(TextEdit {
                start_byte: between_start,
                end_byte: between_end,
                replacement: ", ".to_string(),
            });
        }
    }
}

fn fix_arg_style_params(src: &[u8], root: &Node, edits: &mut Vec<TextEdit>) {
    let len = src.len();
    let mut i = 0;

    while i < len {
        // Look for "arg " keyword, a word of its own: not the end of `karg`
        if i + 4 <= len
            && (i == 0 || !is_ident_char(src[i - 1]))
            && &src[i..i + 3] == b"arg"
            && (src[i + 3] == b' ' || src[i + 3] == b'\t' || src[i + 3] == b'\n')
        {
            if in_string_or_comment(*root, i) {
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

        for &c in &seg[e1 + 1..name2_start] {
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
        PipeParamAddMissingCommas.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_a_missing_comma_is_added() {
        assert_eq!(format("{ |a = 1 b = 2| a }"), "{ |a = 1, b = 2| a }");
        assert_eq!(format("{ arg a = 1 b = 2; a }"), "{ arg a = 1, b = 2; a }");
    }

    #[test]
    fn test_a_name_that_ends_in_arg_is_not_an_argument_list() {
        for src in [
            "var karg, b; karg = b = 2; karg",
            "{ arg a = 1, b = 2; var karg, c; karg = c = 2; a }",
        ] {
            assert_eq!(format(src), src);
        }
    }
}
