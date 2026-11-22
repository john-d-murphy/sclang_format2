use crate::engine::ast::descendants_of_kind;
use crate::engine::text::is_space;
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

/// Ensure that multi-line array literals (`[ ... ]`) have exactly
/// one element per line, but *only* for real collection literals,
/// not for indexing or other uses of `[`.
///
/// This uses the AST to:
///   * Only consider `[` tokens that belong to a `collection` node.
///   * Explicitly skip `indexed_collection` / `index_subrange` uses.
pub struct MultiLineArrayElementsPerLine;

impl Rule for MultiLineArrayElementsPerLine {
    fn name(&self) -> &'static str {
        "multiline_array_elements_per_line"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let buf: &[u8] = bytes;
        let root = cx.tree.root_node();

        let mut edits: Vec<TextEdit> = Vec::new();

        // Walk all `[` tokens in the tree, but restrict ourselves to those
        // that live under a `collection` node (and not under index nodes).
        for bracket in descendants_of_kind(root, "[") {
            one_element_per_line(buf, bracket, &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

/// Puts each element of the array that `bracket` opens on a line of its own,
/// when the array is a literal one and already stands over several lines.
fn one_element_per_line(buf: &[u8], bracket: Node, edits: &mut Vec<TextEdit>) {
    // A literal array's bracket: of the collections and indexes around it,
    // the nearest is a collection, and that collection ends with its `]`.
    let owner = std::iter::successors(bracket.parent(), Node::parent).find(|n| {
        matches!(
            n.kind(),
            "index_subrange" | "indexed_collection" | "collection"
        )
    });
    let Some(end) = owner
        .filter(|n| n.kind() == "collection")
        .and_then(|n| n.child(n.child_count() - 1))
        .filter(|n| n.kind() == "]")
    else {
        return;
    };
    let (open, close) = (bracket.start_byte(), end.start_byte());
    let Some(array) = bracket.parent() else {
        return;
    };

    // Only bother with arrays that are already multi-line.
    if !buf[open + 1..close].contains(&b'\n') {
        return;
    }

    // The array's own commas, from the tree: a comma in a character, a
    // string or an element's own brackets is none of them.
    let mut cursor = array.walk();
    for comma in array.children(&mut cursor).filter(|n| n.kind() == ",") {
        // What follows the comma: on a later line already, or a comment (it
        // stays with the element before it), or the closing bracket.
        let Some(next) = comma.next_sibling() else {
            continue;
        };
        if next.start_position().row != comma.start_position().row
            || matches!(next.kind(), "line_comment" | "block_comment" | "]")
        {
            continue;
        }

        // Otherwise, we have another element starting on the same line.
        // Insert a newline + this line's indent before it.
        let at = next.start_byte();
        let line_start = buf[..at]
            .iter()
            .rposition(|&b| b == b'\n')
            .map_or(0, |i| i + 1);
        let indent = buf[line_start..at]
            .iter()
            .take_while(|&&b| is_space(b))
            .count();
        let indent = String::from_utf8_lossy(&buf[line_start..line_start + indent]);
        edits.push(TextEdit {
            start_byte: at,
            end_byte: at,
            replacement: format!("\n{indent}"),
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
            &grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        MultiLineArrayElementsPerLine.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_each_element_of_an_array_over_several_lines_gets_its_own() {
        assert_eq!(
            format("x = [\n    1, 2,\n    3\n];"),
            "x = [\n    1, \n    2,\n    3\n];"
        );
        assert_eq!(format("x = [1, 2, 3];"), "x = [1, 2, 3];");
    }

    #[test]
    fn test_a_comma_or_a_bracket_in_a_character_or_a_string_is_not_the_arrays() {
        assert_eq!(
            format("x = [\n    $,, 2,\n    3\n];"),
            "x = [\n    $,, \n    2,\n    3\n];"
        );
        assert_eq!(
            format("x = [\n    $(, 1, 2,\n    3\n];"),
            "x = [\n    $(, \n    1, \n    2,\n    3\n];"
        );
        assert_eq!(
            format("x = [\n    \"a, (b\", 2, $], 4,\n    3\n];"),
            "x = [\n    \"a, (b\", \n    2, \n    $], \n    4,\n    3\n];"
        );
        assert_eq!(
            format("x = [\n    f(1, 2), [3, 4], 5\n];"),
            "x = [\n    f(1, 2), \n    [3, 4], \n    5\n];"
        );
    }
}
