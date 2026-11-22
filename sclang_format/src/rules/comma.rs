// src/rules/comma.rs

use crate::engine::ast::end_of_token_before;
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
        walk_for_commas(root, &src, &mut edits);

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }

        Ok(n)
    }
}

fn walk_for_commas(node: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    if should_check_for_commas(node.kind()) {
        space_commas_within(node, src, edits);
        return; // Don't recurse
    }

    // Recursively walk children
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        walk_for_commas(child, src, edits);
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

/// Every comma token within the node, nested lists included. The tree says
/// which `,` is a comma: in `$,` it is a character, in a string or a comment
/// it is text.
fn space_commas_within(node: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    if node.kind() == "," {
        normalize_comma_spacing(src, node, edits);
        return;
    }
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        space_commas_within(child, src, edits);
    }
}

fn normalize_comma_spacing(src: &[u8], comma: Node, edits: &mut Vec<TextEdit>) {
    let comma_pos = comma.start_byte();
    let token_before_end = end_of_token_before(comma);
    let mut left = comma_pos;

    // Scan backwards for spaces before comma
    while left > token_before_end {
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

    #[test]
    fn test_a_character_literal_is_not_a_comma_or_a_blank() {
        assert_eq!(format("x = s.tr($ , $_);"), "x = s.tr($ , $_);");
        assert_eq!(format("y = [$,,1];"), "y = [$,, 1];");
    }
}
