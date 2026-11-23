//! The layout of code is decided by the code, not by the line breaks it was
//! typed with: a text whose line breaks and indents are all taken away, and
//! the same text broken wherever it can be, format to what the text itself
//! formats to.
//!
//! What stays the writer's is left as it was written, and is every
//! exception there is:
//!
//! - a blank line (the scrambler leaves a gap that holds one alone, so the
//!   blank lines between statements stay);
//! - where a comment stands: the gap before a comment and the gap after it
//!   (a comment at the end of its line stays there, and one on a line of its
//!   own keeps it);
//! - the inside of a string, a symbol, a character and a comment;
//! - what the writer asks to be left as written: a region between
//!   `// fmt: off` and `// fmt: on`, and a statement that `// fmt: skip`
//!   trails. Not a byte of those is the formatter's.

mod common;

use common::judge::par_map;
use glob::glob;
use sclang_format::engine::as_written::{kept_as_written, touches};
use tree_sitter::{Node, Parser};

/// The tokens of `node`, in order. A string, a symbol, a character and a
/// comment are each one token, whatever they hold.
fn tokens<'a>(node: Node<'a>, out: &mut Vec<Node<'a>>) {
    let whole = matches!(
        node.kind(),
        "string" | "symbol" | "char" | "line_comment" | "block_comment"
    );
    if whole || node.child_count() == 0 {
        out.push(node);
        return;
    }
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        tokens(child, out);
    }
}

fn parser() -> Parser {
    let mut parser = Parser::new();
    parser
        .set_language(&sclang_format::grammar::language())
        .unwrap();
    parser
}

/// What the scrambler writes between two tokens.
#[derive(Clone, Copy)]
enum Way {
    /// A blank in place of every line break.
    Joined,
    /// A line break, and an indent that means nothing, wherever blanks
    /// stand, inside every bracket and after every semicolon. (Not where
    /// two tokens touch otherwise: a break there puts a blank where the
    /// writer had none, and whether `x.if(a)` has one is not layout.)
    Broken,
}

/// `src` with the gaps between its tokens written anew, each `way`, where
/// that leaves the tree as it was. Nothing when `src` does not parse.
fn scrambled(parser: &mut Parser, src: &str, way: Way) -> Option<String> {
    let tree = parser.parse(src, None)?;
    if tree.root_node().has_error() {
        return None;
    }
    let shape = tree.root_node().to_sexp();
    let kept = kept_as_written(tree.root_node(), src.as_bytes());
    let mut all = Vec::new();
    tokens(tree.root_node(), &mut all);
    let is_comment = |n: &Node| matches!(n.kind(), "line_comment" | "block_comment");
    let opens = |n: &Node| matches!(n.kind(), "(" | "[" | "{" | ";");
    let closes = |n: &Node| matches!(n.kind(), ")" | "]" | "}");
    // The gaps to write anew: where, and what goes there.
    let mut edits: Vec<(usize, usize, String)> = Vec::new();
    for (i, pair) in all.windows(2).enumerate() {
        let (from, to) = (pair[0].end_byte(), pair[1].start_byte());
        if to < from || is_comment(&pair[0]) || is_comment(&pair[1]) || touches(&kept, from, to) {
            continue;
        }
        let gap = &src[from..to];
        if !gap.chars().all(char::is_whitespace) || gap.matches('\n').count() > 1 {
            continue;
        }
        let new = match way {
            Way::Joined if gap.contains('\n') => " ".to_string(),
            Way::Broken if !gap.is_empty() || opens(&pair[0]) || closes(&pair[1]) => {
                format!("\n{}", " ".repeat(i * 7 % 5))
            }
            _ => continue,
        };
        edits.push((from, to, new));
    }
    let apply = |edits: &[&(usize, usize, String)]| {
        let mut text = src.to_string();
        for (from, to, new) in edits.iter().rev() {
            text.replace_range(*from..*to, new);
        }
        text
    };
    let keeps_the_tree = |parser: &mut Parser, text: &str| {
        parser
            .parse(text, None)
            .is_some_and(|tree| tree.root_node().to_sexp() == shape)
    };
    let every: Vec<_> = edits.iter().collect();
    let text = apply(&every);
    if keeps_the_tree(parser, &text) {
        return Some(text);
    }
    // One of them is no legal place: each is tried beside those already
    // taken, and left out when it changes what the text parses to.
    let mut taken = Vec::new();
    for edit in &edits {
        taken.push(edit);
        if !keeps_the_tree(parser, &apply(&taken)) {
            taken.pop();
        }
    }
    Some(apply(&taken))
}

/// What is wrong with how `src` formats once scrambled, if anything.
fn fault(src: &str) -> Option<String> {
    let want = sclang_format::format_source(src).ok()?;
    let mut parser = parser();
    for (way, name) in [(Way::Joined, "joined"), (Way::Broken, "broken")] {
        let text = scrambled(&mut parser, src, way)?;
        match sclang_format::format_source(&text) {
            Ok(got) if got == want => {}
            Ok(got) => {
                let line = want
                    .lines()
                    .zip(got.lines())
                    .position(|(a, b)| a != b)
                    .unwrap_or_else(|| want.lines().count().min(got.lines().count()));
                let at = |text: &str| text.lines().nth(line).unwrap_or("<end>").to_string();
                return Some(format!(
                    "{name}, line {}:\n    as written: {}\n    scrambled:  {}",
                    line + 1,
                    at(&want),
                    at(&got)
                ));
            }
            Err(e) => return Some(format!("{name}: refused: {e:#}")),
        }
    }
    None
}

fn check(pattern: &str, least: usize) {
    let paths: Vec<_> = glob(pattern).unwrap().map(Result::unwrap).collect();
    assert!(
        paths.len() >= least,
        "only {} files match {pattern}",
        paths.len()
    );
    let faults: Vec<String> = par_map(&paths, |path| {
        let src = std::fs::read_to_string(path).unwrap();
        fault(&src).map(|fault| format!("{}: {fault}", path.display()))
    })
    .into_iter()
    .flatten()
    .collect();
    assert!(
        faults.is_empty(),
        "{} of {} files format otherwise once scrambled:\n\n{}",
        faults.len(),
        paths.len(),
        faults
            .iter()
            .take(40)
            .cloned()
            .collect::<Vec<_>>()
            .join("\n\n")
    );
}

#[test]
fn the_scrambler_joins_and_breaks_and_leaves_what_is_the_writers() {
    let mut parser = parser();
    let src = "f = { |a|\n    foo(a,\n        \"b\n c\"); // why\n\n    a\n};\n";
    assert_eq!(
        scrambled(&mut parser, src, Way::Joined).unwrap(),
        "f = { |a| foo(a, \"b\n c\"); // why\n\n    a };\n"
    );
    let broken = scrambled(&mut parser, src, Way::Broken).unwrap();
    assert!(broken.contains("foo(\n"), "{broken:?}");
    assert!(broken.contains("\"b\n c\"\n"), "{broken:?}");
    assert!(broken.contains("; // why\n\n    a\n"), "{broken:?}");
    let bare = |text: &str| text.split_whitespace().collect::<String>();
    assert_eq!(bare(&broken), bare(src));
}

#[test]
fn a_fixture_formats_alike_however_its_lines_are_broken() {
    check("tests/fixtures/**/input.scd", 40);
}

#[test]
fn a_help_form_formats_alike_however_its_lines_are_broken() {
    check("tests/sc_help/**/*.scd", 15_000);
}
