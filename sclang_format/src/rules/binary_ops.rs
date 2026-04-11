// src/rules/binary_ops.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

const fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
}

/// Operators that should have spaces around them
const SPACED_OPERATORS: &[&str] = &[
    // Arithmetic
    "+", "-", "*", "/", "%", "**", // Comparison
    "==", "!=", "<", "<=", ">", ">=", // Logical
    "&&", "||", // Bitwise
    "&", "|", "<<", ">>",  // Assignment
    "=",   // String concatenation
    "+/+", // Array concatenation
    "++",  // Indexing
    "@", "@@", "|@|", "@|@",
];

/// Normalize spaces around binary operators.
pub struct AddSpacesAroundBinaryOps;

impl Rule for AddSpacesAroundBinaryOps {
    fn name(&self) -> &'static str {
        "spaces_around_binary_ops"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src = cx.bytes();

        let mut edits: Vec<TextEdit> = Vec::new();

        walk_tree(root, &src, &mut edits);

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }

        Ok(n)
    }
}

fn walk_tree(node: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    if node.kind() == "binary_expression" {
        process_binary_expression(node, src, edits);
    } else if node.kind() == "duplicated_statement" {
        process_duplicated_statement(node, src, edits);
    } else if node.kind() == "variable_definition" || node.kind() == "function_definition" {
        process_variable_definition(node, src, edits);
    }

    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        walk_tree(child, src, edits);
    }
}

/// Handle variable_definition and function_definition nodes (x = value)
fn process_variable_definition(node: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    // Find the = sign by looking for it between name and value
    let name_node = match node.child_by_field_name("name") {
        Some(n) => n,
        None => return,
    };
    let value_node = match node.child_by_field_name("value") {
        Some(n) => n,
        None => return,
    };

    let name_end = name_node.end_byte();
    let value_start = value_node.start_byte();

    // Find the = in between
    for i in name_end..value_start {
        if src[i] == b'=' {
            fix_operator_spacing(src, i, i + 1, edits);
            break;
        }
    }
}

fn process_binary_expression(node: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    // Get the operator field from the AST
    let op_node = match node.child_by_field_name("operator") {
        Some(n) => n,
        None => return,
    };

    let op_start = op_node.start_byte();
    let op_end = op_node.end_byte();
    let op_text = &src[op_start..op_end];

    // Check if this is an operator we should add spaces around
    let op_str = match std::str::from_utf8(op_text) {
        Ok(s) => s,
        Err(_) => return,
    };

    // Skip if not in our list of spaced operators
    if !SPACED_OPERATORS.contains(&op_str) {
        // Also handle method_name operators (e.g., `foo:`)
        if !op_node.kind().contains("method_name") {
            return;
        }

        // IMPORTANT:
        // Only treat method_name as a binary-operator-like token when it's separated
        // from the left side by whitespace (e.g. `x foo: y`).
        //
        // This avoids breaking constructs where the method_name is glued to a prefix,
        // like event keys `\hello:` or dotted sends `.foo:`.
        if op_start > 0 {
            let prev = src[op_start - 1];
            if !prev.is_ascii_whitespace() {
                return;
            }
        }
    }

    // Special case: skip * if it's inside a class definition (class method marker)
    if op_str == "*" && is_inside_class_def(node) {
        return;
    }

    // Now fix spacing around the operator
    fix_operator_spacing(src, op_start, op_end, edits);
}

/// Check if this node is inside a class_def
fn is_inside_class_def(node: Node) -> bool {
    let mut cur = Some(node);
    while let Some(n) = cur {
        if n.kind() == "class_def" {
            return true;
        }
        cur = n.parent();
    }
    false
}

/// Handle duplicated_statement nodes (the ! duplication operator).
fn process_duplicated_statement(node: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    // Find the ! operator child
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        if child.kind() == "!" {
            fix_operator_spacing(src, child.start_byte(), child.end_byte(), edits);
            break;
        }
    }
}

/// Normalize spaces around an operator: exactly one space before and after.
fn fix_operator_spacing(bytes: &[u8], op_start: usize, op_end: usize, edits: &mut Vec<TextEdit>) {
    let len = bytes.len();

    // ----- left side -----
    let mut l = op_start;
    while l > 0 && bytes[l - 1].is_ascii_whitespace() && !is_newline(bytes[l - 1]) {
        l -= 1;
    }
    if l == op_start {
        // No space before op - insert one
        edits.push(TextEdit {
            start_byte: l,
            end_byte: l,
            replacement: " ".to_string(),
        });
    } else if op_start - l != 1 {
        // Multiple spaces - compress to one
        edits.push(TextEdit {
            start_byte: l,
            end_byte: op_start,
            replacement: " ".to_string(),
        });
    }

    // ----- right side -----
    let mut r = op_end;
    while r < len && bytes[r].is_ascii_whitespace() && !is_newline(bytes[r]) {
        r += 1;
    }
    if r == op_end {
        // No space after op - insert one
        edits.push(TextEdit {
            start_byte: r,
            end_byte: r,
            replacement: " ".to_string(),
        });
    } else if r - op_end != 1 {
        // Multiple spaces - compress to one
        edits.push(TextEdit {
            start_byte: op_end,
            end_byte: r,
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
        let rule = AddSpacesAroundBinaryOps;
        rule.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_adds_spaces_around_plus() {
        assert_eq!(format("a+b"), "a + b");
        assert_eq!(format("a +b"), "a + b");
        assert_eq!(format("a+ b"), "a + b");
    }

    #[test]
    fn test_adds_spaces_around_minus() {
        assert_eq!(format("a-b"), "a - b");
    }

    #[test]
    fn test_adds_spaces_around_multiply() {
        assert_eq!(format("a*b"), "a * b");
    }

    #[test]
    fn test_adds_spaces_around_divide() {
        assert_eq!(format("a/b"), "a / b");
    }

    #[test]
    fn test_adds_spaces_around_comparison() {
        assert_eq!(format("a==b"), "a == b");
        assert_eq!(format("a!=b"), "a != b");
        assert_eq!(format("a<b"), "a < b");
        assert_eq!(format("a<=b"), "a <= b");
        assert_eq!(format("a>b"), "a > b");
        assert_eq!(format("a>=b"), "a >= b");
    }

    #[test]
    fn test_adds_spaces_around_logical() {
        assert_eq!(format("a&&b"), "a && b");
        assert_eq!(format("a||b"), "a || b");
    }

    #[test]
    fn test_path_concatenation_operator() {
        // The +/+ operator should be kept as a single unit
        assert_eq!(
            format(r#"Platform.resourceDir +/+ "sounds/test.wav""#),
            r#"Platform.resourceDir +/+ "sounds/test.wav""#
        );
    }

    #[test]
    fn test_path_concatenation_adds_spaces() {
        assert_eq!(
            format(r#"Platform.resourceDir+/+"sounds/test.wav""#),
            r#"Platform.resourceDir +/+ "sounds/test.wav""#
        );
    }

    #[test]
    fn test_path_concatenation_normalizes_spaces() {
        assert_eq!(
            format(r#"Platform.resourceDir  +/+  "sounds/test.wav""#),
            r#"Platform.resourceDir +/+ "sounds/test.wav""#
        );
    }

    #[test]
    fn test_array_concatenation() {
        assert_eq!(format("[1, 2]++[3, 4]"), "[1, 2] ++ [3, 4]");
    }

    #[test]
    fn test_duplication_operator() {
        assert_eq!(format("sig!2"), "sig ! 2");
        assert_eq!(format("sig  !  2"), "sig ! 2");
    }

    #[test]
    fn test_preserves_existing_single_space() {
        assert_eq!(format("a + b"), "a + b");
        assert_eq!(format("a == b"), "a == b");
    }

    #[test]
    fn test_idempotency() {
        let input = r#"Platform.resourceDir +/+ "sounds/test.wav""#;
        let once = format(input);
        let twice = format(&once);
        assert_eq!(once, twice, "Must be idempotent");
    }

    #[test]
    fn test_idempotency_complex() {
        let input = "a+b*c-d/e";
        let once = format(input);
        let twice = format(&once);
        assert_eq!(once, twice, "Must be idempotent");
    }

    #[test]
    fn test_assignment() {
        assert_eq!(format("x=1"), "x = 1");
        assert_eq!(format("x  =  1"), "x = 1");
    }

    #[test]
    fn test_does_not_touch_unary_minus() {
        // Unary minus shouldn't get spaces added
        // This depends on how tree-sitter parses it
        let input = "a * -1";
        assert_eq!(format(input), "a * -1");
    }

    #[test]
    fn test_does_not_split_symbol_keyword_in_event_pairs() {
        // Regression: don't turn `\hello:` into `\ hello:`
        let input = r"( \hello: 1, \hello: 0 );";
        assert_eq!(format(input), input);
    }

    #[test]
    fn test_does_not_split_compact_symbol_keyword() {
        // Compact style without spaces after parens
        let input = r"(\hello: 1, \hello: 0);";
        assert_eq!(format(input), input);
    }
}
