// src/engine/ast.rs
use crate::engine::text::is_space;
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

/// Whether a comment stands anywhere under `node`.
///
/// A rule that writes a node's text out again in another shape leaves a
/// node with a comment in it as it is: where the comment would go, and
/// whether a line comment would swallow what follows it, is not for the
/// rule to guess.
#[must_use]
pub fn contains_comment(node: Node) -> bool {
    let mut cursor = node.walk();
    node.children(&mut cursor).any(|child| {
        matches!(child.kind(), "line_comment" | "block_comment") || contains_comment(child)
    })
}

/// The tokens under `root` whose kind is one of `kinds`, in the order of the
/// text.
///
/// A token is a leaf of the tree, so a bracket, a quote or a keyword that
/// stands in a string, a symbol, a character or a comment is part of that
/// token and is not met.
#[must_use]
pub fn tokens_of_kinds<'a>(root: Node<'a>, kinds: &[&str]) -> Vec<Node<'a>> {
    fn collect<'a>(node: Node<'a>, kinds: &[&str], out: &mut Vec<Node<'a>>) {
        if node.child_count() == 0 {
            if kinds.contains(&node.kind()) {
                out.push(node);
            }
            return;
        }
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            collect(child, kinds, out);
        }
    }

    let mut out = Vec::new();
    collect(root, kinds, &mut out);
    out
}

/// Where the blanks before `node` begin: no further back than the end of the
/// token before it.
///
/// A character is two bytes whatever the second is, so the blank of `$ ` and
/// the tab of a `$` and a tab are that token's and no space between tokens.
#[must_use]
pub fn blanks_before(bytes: &[u8], node: Node) -> usize {
    let token_end = end_of_token_before(node);
    let mut start = node.start_byte();
    while start > token_end && is_space(bytes[start - 1]) {
        start -= 1;
    }
    start
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

/// The token after `node` in the text: the first leaf of what follows it.
#[must_use]
pub fn next_token(node: Node) -> Option<Node> {
    let mut n = node;
    loop {
        if let Some(next) = n.next_sibling() {
            n = next;
            break;
        }
        n = n.parent()?;
    }
    while let Some(first) = n.child(0) {
        n = first;
    }
    Some(n)
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
