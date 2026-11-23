//! What formatting must keep, counted, for the tests that check it.

use std::collections::{BTreeMap, BTreeSet};
use tree_sitter::{Node, Parser};

/// What must survive formatting, counted: every word, and every other
/// character that is not a blank. Left out are the marks the rules add or
/// remove (`(` `)` `,` `;` `|`) and the word `arg`, which becomes a pair of
/// pipes. Counted and not kept in order, because that same rule moves the
/// parameters ahead of a comment that stood before them. A default written
/// the older way, `name(value)`, counts as the `=` of `name = value`: that
/// same rule writes it so, and the two mean the same. The slashes that
/// open a `//` comment are left out too: a paragraph of comments that is
/// filled again has more lines than it had, or fewer, each with its
/// slashes, and every word it had. (Two slashes together are nothing else
/// in SuperCollider; in a string or a block comment they are left out of
/// both texts alike.)
pub fn essence(src: &str) -> BTreeMap<String, usize> {
    let mut counts = BTreeMap::new();
    let mut word = String::new();
    let chars: Vec<char> = src.chars().chain(std::iter::once(' ')).collect();
    for (i, &c) in chars.iter().enumerate() {
        if c.is_alphanumeric() || c == '_' {
            word.push(c);
            continue;
        }
        if !word.is_empty() && word != "arg" {
            *counts.entry(std::mem::take(&mut word)).or_insert(0) += 1;
        }
        word.clear();
        let opens_a_comment =
            c == '/' && (chars.get(i + 1) == Some(&'/') || (i > 0 && chars[i - 1] == '/'));
        if !c.is_whitespace() && !"(),;|".contains(c) && !opens_a_comment {
            *counts.entry(c.to_string()).or_insert(0) += 1;
        }
    }
    let older_defaults = older_defaults(src);
    if older_defaults > 0 {
        *counts.entry("=".to_string()).or_insert(0) += older_defaults;
    }
    counts
}

/// Each token whose count formatting changed, as `"token" before->after`;
/// empty when every token survived.
pub fn changed_tokens(input: &str, output: &str) -> Vec<String> {
    let (before, after) = (essence(input), essence(output));
    before
        .keys()
        .chain(after.keys())
        .filter(|k| before.get(*k) != after.get(*k))
        .map(|k| {
            format!(
                "{k:?} {}->{}",
                before.get(k).unwrap_or(&0),
                after.get(k).unwrap_or(&0)
            )
        })
        .collect::<BTreeSet<_>>()
        .into_iter()
        .collect()
}

/// How many parameter defaults are written `name(value)`. Only the tree can
/// tell one from a call; in the newer form the value is a node of its own,
/// so a `(` among the parameter's own children is the older form.
fn older_defaults(src: &str) -> usize {
    fn count(node: Node) -> usize {
        let mut cursor = node.walk();
        let children: Vec<Node> = node.children(&mut cursor).collect();
        let own = usize::from(
            matches!(node.kind(), "argument_default" | "pipe_argument")
                && children.iter().any(|c| c.kind() == "("),
        );
        own + children.into_iter().map(count).sum::<usize>()
    }
    let mut parser = Parser::new();
    parser
        .set_language(&sclang_format::grammar::language())
        .unwrap();
    count(parser.parse(src, None).unwrap().root_node())
}
