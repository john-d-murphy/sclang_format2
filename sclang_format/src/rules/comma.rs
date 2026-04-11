// src/rules/comma.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

pub struct AddSpacesAfterCommas;

impl Rule for AddSpacesAfterCommas {
    fn name(&self) -> &'static str {
        "AddSpacesAfterCommas"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src = cx.bytes();

        let mut edits = Vec::new();
        walk_for_commas(root, &src, root, &mut edits);

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }

        Ok(n)
    }
}

/// Check if byte position is inside a string or comment node
fn in_string_or_comment(root: Node, byte: usize) -> bool {
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

fn walk_for_commas(node: Node, src: &[u8], root: Node, edits: &mut Vec<TextEdit>) {
    // Process this node's text for commas
    if should_check_for_commas(node.kind()) {
        check_commas_in_range(src, node.start_byte(), node.end_byte(), root, edits);
        return; // Don't recurse
    }

    // Recursively walk children
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        walk_for_commas(child, src, root, edits);
    }
}

fn should_check_for_commas(kind: &str) -> bool {
    matches!(
        kind,
        "parameter_call_list"
            | "argument_calls"
            | "collection"
            | "event"
            | "parameter_list"
            | "pipe_parameter_list"
            | "variable_definition_sequence"
    )
}

fn check_commas_in_range(
    src: &[u8],
    start: usize,
    end: usize,
    root: Node,
    edits: &mut Vec<TextEdit>,
) {
    let mut i = start;
    while i < end {
        if src[i] == b',' {
            // Use AST to check if we're in a comment or string
            if !in_string_or_comment(root, i) {
                normalize_comma_spacing(src, i, edits);
            }
        }
        i += 1;
    }
}

fn normalize_comma_spacing(src: &[u8], comma_pos: usize, edits: &mut Vec<TextEdit>) {
    let mut left = comma_pos;

    // Scan backwards for spaces before comma
    while left > 0 {
        let b = src[left - 1];
        if b == b' ' || b == b'\t' {
            left -= 1;
        } else {
            break;
        }
    }
    if left < comma_pos {
        edits.push(TextEdit {
            start_byte: left,
            end_byte: comma_pos,
            replacement: String::new(),
        });
    }

    // Scan forwards for spaces after comma
    let mut right = comma_pos + 1;
    while right < src.len() {
        let b = src[right];
        if b == b' ' || b == b'\t' {
            right += 1;
        } else {
            break;
        }
    }

    // If followed by newline, just clean up trailing spaces
    if right < src.len() && (src[right] == b'\n' || src[right] == b'\r') {
        if right > comma_pos + 1 {
            edits.push(TextEdit {
                start_byte: comma_pos + 1,
                end_byte: right,
                replacement: String::new(),
            });
        }
        return;
    }

    let spaces_after = right - (comma_pos + 1);

    if spaces_after == 0 {
        edits.push(TextEdit {
            start_byte: comma_pos + 1,
            end_byte: comma_pos + 1,
            replacement: " ".to_string(),
        });
    } else if spaces_after > 1 {
        edits.push(TextEdit {
            start_byte: comma_pos + 1,
            end_byte: right,
            replacement: " ".to_string(),
        });
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
        let rule = AddSpacesAfterCommas;
        rule.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_adds_space_after_comma() {
        assert_eq!(format("foo(a,b,c)"), "foo(a, b, c)");
    }

    #[test]
    fn test_normalizes_multiple_spaces() {
        assert_eq!(format("foo(a,  b,   c)"), "foo(a, b, c)");
    }

    #[test]
    fn test_removes_space_before_comma() {
        assert_eq!(format("foo(a , b)"), "foo(a, b)");
    }

    #[test]
    fn test_ignores_comma_in_string() {
        let input = r#"foo("a,b,c")"#;
        assert_eq!(format(input), input);
    }

    #[test]
    fn test_ignores_comma_in_line_comment() {
        let input = "// foo(a,b,c)";
        assert_eq!(format(input), input);
    }

    #[test]
    fn test_ignores_comma_in_indented_comment() {
        // This was causing the idempotency failure
        let input = "    //\tb = ActionButton(f,\"hi\",minWidth:140)";
        let result = format(input);
        assert_eq!(result, input, "Should not touch commas inside comments");
    }

    #[test]
    fn test_idempotency_indented_comment() {
        let input = "    //\tb = ActionButton(f,\"hi\",minWidth:140)";
        let once = format(input);
        let twice = format(&once);
        assert_eq!(once, twice, "Must be idempotent");
    }

    #[test]
    fn test_flowview_pattern() {
        // The exact failing pattern
        let input = r#"(
FlowView.new.flow({ arg f;
//	b = ActionButton(f,"hi",minWidth:140)
}).background_(Color.grey)
)"#;
        let once = format(input);
        let twice = format(&once);
        assert_eq!(once, twice, "Must be idempotent");
    }
}
