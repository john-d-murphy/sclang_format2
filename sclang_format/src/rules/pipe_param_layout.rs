// src/rules/pipe_param_layout.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

pub struct PipeParamOnBraceLine;

impl Rule for PipeParamOnBraceLine {
    fn name(&self) -> &'static str {
        "pipe_param_on_brace_line"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src = cx.bytes();

        let mut edits = Vec::new();
        walk_tree(root, src, &mut edits);

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }

        Ok(n)
    }
}

fn walk_tree(node: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    // Look for function_block nodes with pipe parameters
    if node.kind() == "function_block" {
        fix_pipe_param_position(node, src, edits);
    }

    // Recurse to children
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        walk_tree(child, src, edits);
    }
}

fn fix_pipe_param_position(func_block: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    // Find the opening brace and pipe_parameter_list
    let mut brace_node = None;
    let mut param_list = None;

    let mut cursor = func_block.walk();
    if cursor.goto_first_child() {
        loop {
            let child = cursor.node();
            if child.kind() == "{" {
                brace_node = Some(child);
            } else if child.kind() == "parameter_list" {
                // Look for pipe_parameter_list inside
                let mut param_cursor = child.walk();
                if param_cursor.goto_first_child() {
                    loop {
                        if param_cursor.node().kind() == "pipe_parameter_list" {
                            param_list = Some(param_cursor.node());
                            break;
                        }
                        if !param_cursor.goto_next_sibling() {
                            break;
                        }
                    }
                }
            }
            if !cursor.goto_next_sibling() {
                break;
            }
        }
    }

    let Some(brace) = brace_node else { return };
    let Some(pipes) = param_list else { return };

    // Check if there's a newline between { and |
    let brace_end = brace.end_byte();
    let pipes_start = pipes.start_byte();

    if brace_end >= pipes_start {
        return; // Something wrong, bail
    }

    let between = &src[brace_end..pipes_start];

    // A line break in the gap, and nothing in it but space: a comment
    // between the brace and the pipe stays where it is.
    if !between.contains(&b'\n') || !between.iter().all(u8::is_ascii_whitespace) {
        return;
    }

    // Replace the whitespace between { and | with a single space
    edits.push(TextEdit {
        start_byte: brace_end,
        end_byte: pipes_start,
        replacement: " ".to_string(),
    });
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
        PipeParamOnBraceLine.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_pipes_on_the_line_after_the_brace_join_it() {
        assert_eq!(format("f = {\n    |a|\n    a\n};"), "f = { |a|\n    a\n};");
    }

    #[test]
    fn test_a_comment_between_the_brace_and_the_pipes_is_kept() {
        let src = "f = {\n    // why a\n    |a|\n    a\n};";
        assert_eq!(format(src), src);
    }
}
