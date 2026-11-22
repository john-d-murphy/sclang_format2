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
    fn dfs<'a>(node: Node<'a>, kind: &str, out: &mut Vec<Node<'a>>) {
        if node.kind() == kind {
            out.push(node);
        }
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            dfs(child, kind, out);
        }
    }

    let mut out = Vec::new();
    dfs(root, kind, &mut out);
    out.into_iter()
}

/// Where a binary operator ends, its adverb (`+.t`) included: the two are one
/// token to sclang, so nothing may come between them.
#[must_use]
pub fn operator_end(op: Node) -> usize {
    op.next_sibling()
        .filter(|n| n.kind() == "adverb")
        .map_or_else(|| op.end_byte(), |adverb| adverb.end_byte())
}

/// Where the token before `node` ends. The blanks a rule may delete before a
/// token stop here: the blank of the character `$ ` is part of that token.
#[must_use]
pub fn end_of_token_before(node: Node) -> usize {
    let mut n = node;
    loop {
        if let Some(prev) = n.prev_sibling() {
            return prev.end_byte();
        }
        match n.parent() {
            Some(parent) => n = parent,
            None => return 0,
        }
    }
}

/// Whether `node` is a default that sclang stores with the function as it
/// stands.
///
/// That is a number, negative or not, `inf`, `nil`, a boolean, a character,
/// a string, a symbol or a literal array (`#[...]`). Any other default is an
/// expression. Between pipes an expression must stand in parentheses, and a
/// literal must not: a parenthesized default is compiled as code that fills
/// the argument in when it is nil, so `{ |a = (1)| a }.value(nil)` is 1.
#[must_use]
pub fn is_literal_default(node: Node, src: &[u8]) -> bool {
    let text = |n: Node| &src[n.start_byte()..n.end_byte()];
    match node.kind() {
        "literal" => true,
        "variable" => matches!(text(node), b"nil" | b"inf"),
        "collection" => src[node.start_byte()] == b'#',
        "unary_expression" | "pipe_safe_unary_expression" => {
            src[node.start_byte()] == b'-'
                && node
                    .child_by_field_name("right")
                    .is_some_and(|right| match right.kind() {
                        "literal" => right.child(0).is_some_and(|n| n.kind() == "number"),
                        "variable" => text(right) == b"inf",
                        _ => false,
                    })
        }
        _ => false,
    }
}
