// src/engine/ast.rs
use tree_sitter::Node;

/// Return true if the byte offset is inside a string or comment node.
#[must_use]
pub fn in_string_or_comment(root: Node, byte: usize) -> bool {
    let mut cur = root.descendant_for_byte_range(byte, byte + 1);
    while let Some(n) = cur {
        match n.kind() {
            // extend this list if your grammar uses different names
            "string" | "comment" | "block_comment" | "line_comment" => return true,
            _ => cur = n.parent(),
        }
    }
    false
}

/// Collect all descendants of `root` whose `kind()` matches `kind`.
/// Simple DFS that returns a Vec-backed iterator (no lifetime tricks).
pub fn descendants_of_kind<'a>(root: Node<'a>, kind: &str) -> impl Iterator<Item = Node<'a>> {
    let mut out = Vec::new();

    fn dfs<'a>(node: Node<'a>, kind: &str, out: &mut Vec<Node<'a>>) {
        if node.kind() == kind {
            out.push(node);
        }
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            dfs(child, kind, out);
        }
    }

    dfs(root, kind, &mut out);
    out.into_iter()
}
