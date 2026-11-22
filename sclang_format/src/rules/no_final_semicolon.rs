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
    // The final semicolons are the block's last children, comments and the
    // closing brace aside. Whatever the last statement is (a return too), a
    // `;` that a statement follows is never one of them.
    let mut cursor = node.walk();
    let children: Vec<Node> = node.children(&mut cursor).collect();
    for child in children.iter().rev() {
        match child.kind() {
            "}" | "line_comment" | "block_comment" => {}
            ";" => edits.push(TextEdit {
                start_byte: child.start_byte(),
                end_byte: child.end_byte(),
                replacement: String::new(),
            }),
            _ => break,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::engine::{Ctx, IndentStyle};
    use crate::grammar;

    fn format(src: &str) -> String {
        let mut cx = Ctx::new(
            src.to_string(),
            grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        NoFinalSemicolon.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_a_return_is_a_last_statement() {
        assert_eq!(
            format("Foo { init { |a| name = a; ^this } }"),
            "Foo { init { |a| name = a; ^this } }"
        );
        assert_eq!(format("Foo { bar { a.foo; ^b; } }"), "Foo { bar { a.foo; ^b } }");
    }

    #[test]
    fn test_removes_the_semicolon_before_a_closing_comment() {
        assert_eq!(format("f = { a.foo; /* c */ };"), "f = { a.foo /* c */ };");
    }

    #[test]
    fn test_keeps_a_var_lines_own_semicolon() {
        assert_eq!(format("f = { var a; };"), "f = { var a; };");
    }
}
