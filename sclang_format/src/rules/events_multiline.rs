use crate::engine::ast::descendants_of_kind;
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

pub struct MultiLineEventsOnePerLine;

impl Rule for MultiLineEventsOnePerLine {
    fn name(&self) -> &'static str {
        "multi_line_events_one_per_line"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes();
        let bytes: &[u8] = src;
        let root = cx.tree.root_node();
        let mut edits: Vec<TextEdit> = Vec::new();

        // Process `event` nodes: (key: val, key: val)
        for node in descendants_of_kind(root, "event") {
            process_associative_node(node, bytes, &mut edits);
        }

        // Also process `collection` nodes that start with `(` and contain
        // associative_item children (the grammar sometimes parses mixed
        // content this way instead of as `event`).
        for node in descendants_of_kind(root, "collection") {
            if bytes.get(node.start_byte()) != Some(&b'(') {
                continue;
            }
            let has_assoc = node_has_child_kind(node, "associative_item");
            if !has_assoc {
                continue;
            }
            process_associative_node(node, bytes, &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

fn node_has_child_kind(node: Node, kind: &str) -> bool {
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        if child.kind() == kind {
            return true;
        }
    }
    false
}

/// For an event or collection node containing `associative_items`,
/// ensure each key:value pair is on its own line.
fn process_associative_node(node: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    // Must span multiple lines (or have multiple items on one line)
    // to be worth processing.  We check for items sharing a row below,
    // but bail early on single-line nodes.
    if node.start_position().row == node.end_position().row {
        return;
    }

    // Collect associative_item children in order.
    let mut items: Vec<Node> = Vec::new();
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        if child.kind() == "associative_item" {
            items.push(child);
        }
    }

    if items.len() < 2 {
        return;
    }

    // Determine the target indent: use the leading whitespace of the
    // first associative_item's line.
    let indent = leading_whitespace_of_line(src, items[0].start_byte());

    // For each consecutive pair on the same row, insert a line break
    // after the comma that separates them.
    for pair in items.windows(2) {
        let item1 = pair[0];
        let item2 = pair[1];

        // Only split if they're on the same line.
        if item1.start_position().row != item2.start_position().row {
            continue;
        }

        // The comma between them is the token after item1. Only space
        // between it and item2 is replaced: a comment there stays where
        // it is, and the two items with it.
        let Some(comma) = item1.next_sibling().filter(|n| n.kind() == ",") else {
            continue;
        };
        let (comma_byte, gap_end) = (comma.start_byte(), item2.start_byte());
        if !src[comma.end_byte()..gap_end]
            .iter()
            .all(u8::is_ascii_whitespace)
        {
            continue;
        }

        // Replace from comma through all trailing whitespace (up to item2)
        // with ",\n<indent>".
        edits.push(TextEdit {
            start_byte: comma_byte,
            end_byte: gap_end,
            replacement: format!(",\n{indent}"),
        });
    }
}

/// Extract the leading whitespace from the line containing `byte_pos`.
fn leading_whitespace_of_line(src: &[u8], byte_pos: usize) -> String {
    // Walk backwards to find line start.
    let mut line_start = byte_pos;
    while line_start > 0 && src[line_start - 1] != b'\n' {
        line_start -= 1;
    }

    // Walk forward to find end of leading whitespace.
    let mut ws_end = line_start;
    while ws_end < src.len() && (src[ws_end] == b' ' || src[ws_end] == b'\t') {
        ws_end += 1;
    }

    String::from_utf8_lossy(&src[line_start..ws_end]).to_string()
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
        MultiLineEventsOnePerLine.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_each_pair_of_an_event_over_several_lines_gets_its_own() {
        assert_eq!(
            format("x = (\n    a: $,, b: 2,\n    c: \"x, y\", d: 4\n);"),
            "x = (\n    a: $,,\n    b: 2,\n    c: \"x, y\",\n    d: 4\n);"
        );
    }

    #[test]
    fn test_a_comment_after_the_comma_is_kept() {
        let src = "x = (\n    a: 1, /*c*/ b: 2,\n    c: 3\n);";
        assert_eq!(format(src), src);
    }
}
