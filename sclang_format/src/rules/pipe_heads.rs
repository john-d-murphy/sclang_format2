// src/rules/pipe_heads.rs
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

pub struct PipeHeadSpacing;

impl Rule for PipeHeadSpacing {
    fn name(&self) -> &'static str {
        "pipe_head_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let mut edits = Vec::new();

        {
            let tree = &cx.tree;
            let src = cx.bytes();
            let root = tree.root_node();

            let mut cursor = root.walk();
            visit_pipe_params(&mut cursor, &src, &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

fn visit_pipe_params(cursor: &mut tree_sitter::TreeCursor, src: &[u8], edits: &mut Vec<TextEdit>) {
    let node = cursor.node();

    if node.kind() == "pipe_parameter_list" {
        if !is_valid_context(node) {
            return;
        }
        fix_pipe_spacing(node, src, edits);
    }

    if cursor.goto_first_child() {
        loop {
            visit_pipe_params(cursor, src, edits);
            if !cursor.goto_next_sibling() {
                break;
            }
        }
        cursor.goto_parent();
    }
}

fn is_valid_context(pipe_list_node: tree_sitter::Node) -> bool {
    let mut current = pipe_list_node.parent();
    while let Some(node) = current {
        if node.kind() == "function_block" {
            if let Some(parent) = node.parent() {
                if parent.kind() == "function_call" {
                    let mut has_receiver = false;
                    let mut cursor = parent.walk();
                    if cursor.goto_first_child() {
                        loop {
                            if cursor.field_name() == Some("receiver") {
                                has_receiver = true;
                                break;
                            }
                            if !cursor.goto_next_sibling() {
                                break;
                            }
                        }
                    }

                    if !has_receiver {
                        return false;
                    }
                }
            }
            break;
        }
        current = node.parent();
    }
    true
}

fn fix_pipe_spacing(pipe_list: tree_sitter::Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    // Find parent function_block to get the opening brace
    let func_block = pipe_list.parent().and_then(|p| {
        if p.kind() == "parameter_list" {
            p.parent()
        } else {
            Some(p)
        }
    });

    let Some(func_block) = func_block else { return };
    if func_block.kind() != "function_block" {
        return;
    }

    // Find the opening brace token through the AST
    let mut brace_node = None;
    let mut cursor = func_block.walk();
    if cursor.goto_first_child() {
        loop {
            if cursor.node().kind() == "{" {
                brace_node = Some(cursor.node());
                break;
            }
            if !cursor.goto_next_sibling() {
                break;
            }
        }
    }

    let Some(brace) = brace_node else { return };

    // Find the left and right pipe tokens
    let mut left_pipe = None;
    let mut right_pipe = None;
    let mut cursor = pipe_list.walk();
    if cursor.goto_first_child() {
        loop {
            let child = cursor.node();
            if child.kind() == "pipe_token" {
                if left_pipe.is_none() {
                    left_pipe = Some(child);
                } else {
                    right_pipe = Some(child);
                    break;
                }
            }
            if !cursor.goto_next_sibling() {
                break;
            }
        }
    }

    let Some(left) = left_pipe else { return };
    let Some(right) = right_pipe else { return };

    // 1) Ensure exactly one space between { and |
    let brace_end = brace.end_byte();
    let left_start = left.start_byte();

    // Handle both adjacent {| and spaced { | cases
    if brace_end <= left_start {
        let current_spacing = &src[brace_end..left_start];
        if current_spacing != b" " {
            // Replace whatever spacing exists (including none) with exactly one space
            edits.push(TextEdit {
                start_byte: brace_end,
                end_byte: left_start,
                replacement: " ".to_string(),
            });
        }
    }

    // 2) Remove spaces immediately after left pipe
    let inner_start = left.end_byte();
    let mut space_end = inner_start;
    while space_end < src.len() && (src[space_end] == b' ' || src[space_end] == b'\t') {
        space_end += 1;
    }

    if space_end > inner_start {
        edits.push(TextEdit {
            start_byte: inner_start,
            end_byte: space_end,
            replacement: String::new(),
        });
    }

    // 3) Remove spaces immediately before right pipe
    let inner_end = right.start_byte();
    let mut space_start = inner_end;
    while space_start > left.end_byte()
        && (src[space_start - 1] == b' ' || src[space_start - 1] == b'\t')
    {
        space_start -= 1;
    }

    if space_start < inner_end {
        edits.push(TextEdit {
            start_byte: space_start,
            end_byte: inner_end,
            replacement: String::new(),
        });
    }
}
