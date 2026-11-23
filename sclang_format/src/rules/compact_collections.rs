use crate::engine::ast::{contains_comment, descendants_of_kind};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use crate::rules::width::{is_too_wide, text_end_of_line, text_start_of_line};
use anyhow::Result;
use tree_sitter::Node;

/// Check if a node is "literal-ish" (safe to compact).
/// Based on AST node kinds from tree-sitter-supercollider.
fn is_literal_ish_node(node: Node) -> bool {
    match node.kind() {
        // Direct literals (numbers, strings, symbols) and simple variable
        // references
        "literal" | "variable" => true,

        // Unary expression: allow only negative literals like -1, -3.14
        "unary_expression" => {
            // Check structure: should be `-` followed by a `literal`
            let mut has_minus = false;
            let mut has_literal = false;
            let mut has_other = false;

            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                match child.kind() {
                    "-" => has_minus = true,
                    "literal" => has_literal = true,
                    _ => has_other = true,
                }
            }

            has_minus && has_literal && !has_other
        }

        // Everything else is not literal-ish:
        // - code_block (parenthesized expressions)
        // - function_call (method calls)
        // - collection (nested arrays)
        // - binary_expression (operators)
        // - etc.
        _ => false,
    }
}

/// Check if a collection node is multiline
fn is_multiline(node: Node) -> bool {
    let start_row = node.start_position().row;
    let end_row = node.end_position().row;
    start_row != end_row
}

/// Get the element nodes from a collection (skip punctuation)
fn get_elements(node: Node) -> Vec<Node> {
    let mut elements = Vec::new();
    let mut cursor = node.walk();

    for child in node.children(&mut cursor) {
        // Everything but punctuation and comments is an element
        if !matches!(
            child.kind(),
            "[" | "]" | "," | "line_comment" | "block_comment"
        ) {
            elements.push(child);
        }
    }

    elements
}

/// Check if a collection has a trailing comma (user wants multiline)
fn has_trailing_comma(node: Node) -> bool {
    let mut cursor = node.walk();
    let children: Vec<_> = node.children(&mut cursor).collect();

    // Walk backwards from the end, skipping closing delimiters and whitespace/comments
    // If we hit a `,` before hitting an element, there's a trailing comma
    for child in children.iter().rev() {
        match child.kind() {
            // Skip closing delimiters and comments
            "]" | ")" | "line_comment" | "block_comment" => {}
            "," => return true,
            _ => return false, // Hit an element before a comma
        }
    }
    false
}

/// Check if an element node spans multiple lines
fn element_is_multiline(node: Node) -> bool {
    let start_row = node.start_position().row;
    let end_row = node.end_position().row;
    start_row != end_row
}

pub struct CompactShortCollections;

impl Rule for CompactShortCollections {
    fn name(&self) -> &'static str {
        "compact_short_collections"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let src: &[u8] = bytes;
        let root = cx.tree.root_node();

        let mut edits: Vec<TextEdit> = Vec::new();

        // Iterate over collection nodes directly (AST-first)
        for collection in descendants_of_kind(root, "collection") {
            // Check if it's a [ ] array (not an event with parens)
            let first_byte = src.get(collection.start_byte()).copied();
            if first_byte != Some(b'[') {
                continue;
            }

            // Skip if this is inside an indexed_collection (array indexing, not literal)
            let mut dominated_by_indexing = false;
            let mut parent = collection.parent();
            while let Some(p) = parent {
                if p.kind() == "indexed_collection" || p.kind() == "index_subrange" {
                    dominated_by_indexing = true;
                    break;
                }
                parent = p.parent();
            }
            if dominated_by_indexing {
                continue;
            }

            // Must be multiline to be worth compacting
            if !is_multiline(collection) {
                continue;
            }

            // Skip if has trailing comma (user explicitly wants multiline)
            if has_trailing_comma(collection) {
                continue;
            }

            // Skip if contains comments
            if contains_comment(collection) {
                continue;
            }

            // Skip if contains associative_item (event-style key: value)
            if descendants_of_kind(collection, "associative_item")
                .next()
                .is_some()
            {
                continue;
            }

            // Get elements
            let elements = get_elements(collection);

            // Need at least 2 elements to compact
            if elements.len() < 2 {
                continue;
            }

            // Gate 1: All elements must be single-line
            if elements.iter().any(|e| element_is_multiline(*e)) {
                continue;
            }

            // Gate 2: All elements must be literal-ish
            if !elements.iter().all(|e| is_literal_ish_node(*e)) {
                continue;
            }

            // Build the compacted form
            let mut parts = Vec::new();
            for elem in &elements {
                // The element as it stands: its last byte may be the blank
                // of the character `$ `.
                parts.push(String::from_utf8_lossy(&src[elem.byte_range()]).to_string());
            }

            let inner_joined = parts.join(", ");
            let replacement = format!("[{inner_joined}]");

            // Gate 3: the line must not be too wide with the array whole
            // on it.
            let (open, close) = (collection.start_byte(), collection.end_byte());
            let first = text_start_of_line(src, open);
            let line = [
                &src[first..open],
                replacement.as_bytes(),
                &src[close..text_end_of_line(cx, close)],
            ];
            if !is_too_wide(cx, first, &line) {
                edits.push(TextEdit {
                    start_byte: open,
                    end_byte: close,
                    replacement,
                });
            }
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use tree_sitter::Parser;

    fn parse_source(src: &str) -> tree_sitter::Tree {
        let mut parser = Parser::new();
        parser
            .set_language(&crate::grammar::language())
            .expect("Error loading SuperCollider grammar");
        parser.parse(src, None).expect("Failed to parse")
    }

    // ========== is_literal_ish_node tests ==========

    fn check_first_element_is_literal_ish(src: &str) -> bool {
        let tree = parse_source(src);
        let root = tree.root_node();

        // Find the collection
        for node in descendants_of_kind(root, "collection") {
            let elements = get_elements(node);
            if let Some(first) = elements.first() {
                return is_literal_ish_node(*first);
            }
        }
        false
    }

    #[test]
    fn literal_ish_accepts_integers() {
        assert!(check_first_element_is_literal_ish("[1]"));
        assert!(check_first_element_is_literal_ish("[42]"));
        assert!(check_first_element_is_literal_ish("[100]"));
    }

    #[test]
    fn literal_ish_accepts_floats() {
        assert!(check_first_element_is_literal_ish("[3.14]"));
        assert!(check_first_element_is_literal_ish("[0.5]"));
        assert!(check_first_element_is_literal_ish("[123.456]"));
    }

    #[test]
    fn literal_ish_accepts_negative_numbers() {
        assert!(check_first_element_is_literal_ish("[-1]"));
        assert!(check_first_element_is_literal_ish("[-42]"));
        assert!(check_first_element_is_literal_ish("[-3.14]"));
    }

    #[test]
    fn literal_ish_accepts_strings() {
        assert!(check_first_element_is_literal_ish("[\"foo\"]"));
        assert!(check_first_element_is_literal_ish("[\"hello world\"]"));
    }

    #[test]
    fn literal_ish_accepts_symbols() {
        assert!(check_first_element_is_literal_ish("[\\foo]"));
        assert!(check_first_element_is_literal_ish("[\\default]"));
    }

    #[test]
    fn literal_ish_accepts_identifiers() {
        assert!(check_first_element_is_literal_ish("[foo]"));
        assert!(check_first_element_is_literal_ish("[myVar]"));
        assert!(check_first_element_is_literal_ish("[x]"));
    }

    #[test]
    fn literal_ish_rejects_binary_expressions() {
        // These get wrapped in code_block due to parens
        assert!(!check_first_element_is_literal_ish("[(1 + 2)]"));
        assert!(!check_first_element_is_literal_ish("[(a * b)]"));
    }

    #[test]
    fn literal_ish_rejects_method_calls() {
        assert!(!check_first_element_is_literal_ish("[foo.bar]"));
        assert!(!check_first_element_is_literal_ish("[x.postln]"));
    }

    #[test]
    fn literal_ish_rejects_nested_collections() {
        assert!(!check_first_element_is_literal_ish("[[1, 2]]"));
        assert!(!check_first_element_is_literal_ish("[[]]"));
    }

    // ========== Full compaction tests ==========

    /// What the rule makes of `input`, when it changes it.
    fn run_compact(input: &str) -> Option<String> {
        let mut cx = Ctx::new(
            input.to_string(),
            &crate::grammar::language(),
            crate::engine::IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        CompactShortCollections.run(&mut cx).unwrap();
        let output = cx.to_string();
        (output != input).then_some(output)
    }

    #[test]
    fn compact_measures_the_line_with_the_indent_it_will_have() {
        // 59 columns once joined. The line stands at no depth, so the 30
        // blanks before it will go, and are not counted.
        let numbers = vec!["1000"; 9].join(",\n");
        let src = format!("{}x = [\n{numbers}\n];", " ".repeat(30));
        let joined = run_compact(&src).unwrap();
        assert_eq!(joined.trim_start().len(), 59);
        assert!(!joined.contains('\n'));

        // 77 columns once joined, and one level deep: 81 with the indent it
        // will have, though the line has none now.
        let numbers = vec!["1000"; 12].join(",\n");
        let src = format!("f = {{\nx = [\n{numbers}\n];\n}};");
        assert_eq!(run_compact(&src), None);
    }

    #[test]
    fn compact_keeps_the_blank_of_the_space_character() {
        assert_eq!(
            run_compact("x = [1, 2,   $ \n];"),
            Some("x = [1, 2, $ ];".to_string())
        );
        assert_eq!(
            run_compact("x = [$\t,\n    $ ,\n    3\n];"),
            Some("x = [$\t, $ , 3];".to_string())
        );
    }

    #[test]
    fn compact_simple_numbers() {
        let input = "[\n    1,\n    2,\n    3\n]";
        let result = run_compact(input);
        assert_eq!(result, Some("[1, 2, 3]".to_string()));
    }

    #[test]
    fn compact_simple_strings() {
        let input = "[\n    \"foo\",\n    \"bar\"\n]";
        let result = run_compact(input);
        assert_eq!(result, Some("[\"foo\", \"bar\"]".to_string()));
    }

    #[test]
    fn compact_negative_numbers() {
        let input = "[\n    -1,\n    -2,\n    -3\n]";
        let result = run_compact(input);
        assert_eq!(result, Some("[-1, -2, -3]".to_string()));
    }

    #[test]
    fn compact_float_numbers() {
        let input = "[\n    3.14,\n    2.71,\n    1.41\n]";
        let result = run_compact(input);
        assert_eq!(result, Some("[3.14, 2.71, 1.41]".to_string()));
    }

    #[test]
    fn compact_symbols() {
        let input = "[\n    \\a,\n    \\b,\n    \\c\n]";
        let result = run_compact(input);
        assert_eq!(result, Some("[\\a, \\b, \\c]".to_string()));
    }

    #[test]
    fn no_compact_expressions() {
        let input = "[\n    (1 + 2),\n    (3 * 4)\n]";
        let result = run_compact(input);
        assert_eq!(result, None, "Should not compact arrays with expressions");
    }

    #[test]
    fn no_compact_method_calls() {
        let input = "[\n    foo.bar,\n    baz.qux\n]";
        let result = run_compact(input);
        assert_eq!(result, None, "Should not compact arrays with method calls");
    }

    #[test]
    fn no_compact_nested_arrays() {
        let input = "[\n    [1, 2],\n    [3, 4]\n]";
        let result = run_compact(input);
        assert_eq!(result, None, "Should not compact arrays with nested arrays");
    }

    #[test]
    fn no_compact_with_comments() {
        let input = "[\n    1,  // comment\n    2\n]";
        let result = run_compact(input);
        assert_eq!(result, None, "Should not compact arrays with comments");
    }

    #[test]
    fn no_compact_single_line_already() {
        let input = "[1, 2, 3]";
        let result = run_compact(input);
        assert_eq!(
            result, None,
            "Should not compact already-single-line arrays"
        );
    }

    #[test]
    fn no_compact_single_element() {
        let input = "[\n    1\n]";
        let result = run_compact(input);
        assert_eq!(result, None, "Should not compact single-element arrays");
    }

    // ========== Trailing comma tests ==========

    #[test]
    fn no_compact_with_trailing_comma() {
        // Trailing comma signals "keep multiline"
        let input = "[\n    1,\n    2,\n    3,\n]";
        let result = run_compact(input);
        assert_eq!(
            result, None,
            "Should not compact arrays with trailing comma"
        );
    }

    #[test]
    fn compact_without_trailing_comma() {
        // No trailing comma means "okay to compact"
        let input = "[\n    1,\n    2,\n    3\n]";
        let result = run_compact(input);
        assert_eq!(result, Some("[1, 2, 3]".to_string()));
    }

    #[test]
    fn has_trailing_comma_detection() {
        let tree = parse_source("[\n    1,\n    2,\n]");
        let root = tree.root_node();
        for collection in descendants_of_kind(root, "collection") {
            assert!(
                has_trailing_comma(collection),
                "Should detect trailing comma"
            );
        }

        let tree2 = parse_source("[\n    1,\n    2\n]");
        let root2 = tree2.root_node();
        for collection in descendants_of_kind(root2, "collection") {
            assert!(
                !has_trailing_comma(collection),
                "Should not detect trailing comma when absent"
            );
        }
    }

    #[test]
    fn trailing_comma_with_whitespace() {
        // Trailing comma with extra whitespace before ]
        let input = "[\n    1,\n    2,\n    3,\n    \n]";
        let result = run_compact(input);
        assert_eq!(
            result, None,
            "Should detect trailing comma even with whitespace before ]"
        );
    }

    #[test]
    fn trailing_comma_compact_vs_expand() {
        // Black-style convention: trailing comma = keep expanded

        // WITH trailing comma - stays multiline
        let with_trailing = "[\n    \\freq,\n    440,\n    \\amp,\n    0.1,\n]";
        assert_eq!(
            run_compact(with_trailing),
            None,
            "Trailing comma should prevent compaction"
        );

        // WITHOUT trailing comma - can be compacted
        let without_trailing = "[\n    \\freq,\n    440,\n    \\amp,\n    0.1\n]";
        assert_eq!(
            run_compact(without_trailing),
            Some("[\\freq, 440, \\amp, 0.1]".to_string()),
            "No trailing comma should allow compaction"
        );
    }

    #[test]
    fn trailing_comma_single_element() {
        // Single element with trailing comma
        let input = "[\n    1,\n]";
        let result = run_compact(input);
        // Single element arrays aren't compacted anyway (need >= 2)
        assert_eq!(result, None);
    }

    #[test]
    fn trailing_comma_preserves_user_intent() {
        // User explicitly formatted with trailing comma = keep it that way
        // This is the key "Black-style" behavior

        // Short array that COULD fit on one line, but has trailing comma
        let input = "[\n    1,\n    2,\n]";
        let result = run_compact(input);
        assert_eq!(
            result, None,
            "Even short arrays should stay expanded if they have trailing comma"
        );
    }

    #[test]
    fn no_trailing_comma_allows_compaction() {
        // Without trailing comma, formatter is free to compact
        let input = "[\n    \"a\",\n    \"b\",\n    \"c\"\n]";
        let result = run_compact(input);
        assert_eq!(
            result,
            Some("[\"a\", \"b\", \"c\"]".to_string()),
            "No trailing comma means formatter can compact"
        );
    }

    #[test]
    fn trailing_comma_with_comment_before_bracket() {
        // Comment after last element, no trailing comma
        let tree = parse_source("[\n    1,\n    2  // last\n]");
        let root = tree.root_node();
        for collection in descendants_of_kind(root, "collection") {
            // No trailing comma - the comment is attached to element 2
            assert!(
                !has_trailing_comma(collection),
                "Comment after last element without trailing comma"
            );
        }

        // With actual trailing comma before closing bracket
        let tree2 = parse_source("[\n    1,\n    2,\n]");
        let root2 = tree2.root_node();
        for collection in descendants_of_kind(root2, "collection") {
            assert!(
                has_trailing_comma(collection),
                "Should detect trailing comma"
            );
        }
    }
}
