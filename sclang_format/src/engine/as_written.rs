// src/engine/as_written.rs
//! What the writer asks to be left as written, as Black has it:
//!
//! - From a `// fmt: off` comment on a line of its own to the `// fmt: on`
//!   that follows it at the same depth, or to the end of the block (or
//!   file) the comment stands in where none does, every byte stays: line
//!   breaks, indents, blanks, comments. The two comments keep their lines
//!   and are formatted like any other.
//! - A `// fmt: skip` comment at the end of a line of code leaves the
//!   statement that code is in as written, all of its lines, and the
//!   comment with it: the innermost statement, where one holds another.
//!
//! The text must parse all the same: a region excuses no broken code.

use crate::engine::ast_utils::{begins_line, is_comment};
use tree_sitter::Node;

/// What a comment asks for, when it is one of the three.
#[derive(Clone, Copy, PartialEq, Eq)]
pub enum Marker {
    Off,
    On,
    Skip,
}

/// The marker the `//` comment `text` is: `fmt:` and one of the three
/// words, with or without blanks around them, and nothing else.
#[must_use]
pub fn marker(text: &[u8]) -> Option<Marker> {
    let word = text
        .strip_prefix(b"//")?
        .trim_ascii()
        .strip_prefix(b"fmt:")?
        .trim_ascii_start();
    match word {
        b"off" => Some(Marker::Off),
        b"on" => Some(Marker::On),
        b"skip" => Some(Marker::Skip),
        _ => None,
    }
}

/// Whether `node` holds statements, each on a line of its own: a file, a
/// block, the body of a class, parentheses with statements between them.
fn holds_statements(node: Node) -> bool {
    match node.kind() {
        "source_file" | "function_block" | "class_def" => true,
        "code_block" => {
            let mut cursor = node.walk();
            node.parent().is_some_and(|p| p.kind() == "source_file")
                || node
                    .children(&mut cursor)
                    .any(|n| matches!(n.kind(), ";" | "variable_definition_sequence"))
        }
        _ => false,
    }
}

/// The marker comments under `node`, in the order of the text.
fn markers<'a>(node: Node<'a>, src: &[u8], out: &mut Vec<(Node<'a>, Marker)>) {
    if node.kind() == "line_comment" {
        out.extend(marker(&src[node.byte_range()]).map(|marker| (node, marker)));
        return;
    }
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        markers(child, src, out);
    }
}

/// Where the line that holds `at` begins.
fn line_start(src: &[u8], at: usize) -> usize {
    src[..at]
        .iter()
        .rposition(|&b| b == b'\n')
        .map_or(0, |i| i + 1)
}

/// The node before `node` under what holds both, comments apart.
fn before(node: Node) -> Option<Node> {
    std::iter::successors(node.prev_sibling(), Node::prev_sibling).find(|n| !is_comment(*n))
}

/// The node after `node` under what holds both, comments apart.
fn after(node: Node) -> Option<Node> {
    std::iter::successors(node.next_sibling(), Node::next_sibling).find(|n| !is_comment(*n))
}

/// What holds statements and holds `node`, innermost.
fn holder_of(node: Node) -> Option<Node> {
    std::iter::successors(node.parent(), Node::parent).find(|p| holds_statements(*p))
}

/// The statement that the code before the comment `skip` is in, with its
/// semicolon: where it begins and ends.
fn statement_before(skip: Node, root: Node, src: &[u8]) -> Option<(usize, usize)> {
    let code_end = src[..skip.start_byte()]
        .iter()
        .rposition(|b| !b.is_ascii_whitespace())?;
    // The child of what holds statements that the code is in.
    let mut node = root.descendant_for_byte_range(code_end, code_end + 1)?;
    // (A bracket that ends the code is the end of what it closes.)
    while let Some(parent) = node
        .parent()
        .filter(|p| !holds_statements(*p) || matches!(node.kind(), "{" | "}" | "(" | ")"))
    {
        node = parent;
    }
    let (first, last) = if node.parent()?.kind() == "class_def" {
        // A member of a class is the class's own children up to the
        // semicolon of a declaration, or the body of a method.
        let ends = |n: Node| matches!(n.kind(), ";" | "function_block");
        let mut last = node;
        while !ends(last) {
            last = after(last).filter(|n| n.kind() != "}")?;
        }
        let mut first = last;
        while let Some(n) = before(first).filter(|n| !ends(*n) && n.kind() != "{") {
            first = n;
        }
        (first, last)
    } else {
        let is_statement =
            |n: &Node| !matches!(n.kind(), "{" | "}" | "(" | ")" | ";" | "parameter_list");
        if node.kind() == ";" {
            (before(node).filter(is_statement)?, node)
        } else {
            let semicolon = after(node).filter(|n| n.kind() == ";");
            (Some(node).filter(is_statement)?, semicolon.unwrap_or(node))
        }
    };
    Some((first.start_byte(), last.end_byte().max(skip.end_byte())))
}

/// The stretches of the text that are left byte for byte as written, in
/// order, none touching another.
#[must_use]
pub fn kept_as_written(root: Node, src: &[u8]) -> Vec<(usize, usize)> {
    // No file without the word has a marker, and most have not.
    if !src.windows(4).any(|w| w == b"fmt:") {
        return Vec::new();
    }
    let mut found = Vec::new();
    markers(root, src, &mut found);
    let mut kept: Vec<(usize, usize)> = Vec::new();
    for (i, &(comment, marker)) in found.iter().enumerate() {
        let own_line = begins_line(comment, src);
        let range = match marker {
            Marker::Off if own_line => holder_of(comment).map(|holder| {
                let on = found[i + 1..].iter().find(|(n, marker)| {
                    *marker == Marker::On
                        && begins_line(*n, src)
                        && holder_of(*n).is_some_and(|h| h.id() == holder.id())
                });
                let end = match on {
                    Some((on, _)) => line_start(src, on.start_byte()),
                    None if holder.kind() == "source_file" => src.len(),
                    None => {
                        let close = holder.child(holder.child_count() - 1).unwrap_or(holder);
                        if begins_line(close, src) {
                            line_start(src, close.start_byte())
                        } else {
                            close.start_byte()
                        }
                    }
                };
                // From the line break that ends the comment's line, so
                // that nothing is put before the first of the lines kept.
                (comment.end_byte(), end)
            }),
            Marker::Skip if !own_line => statement_before(comment, root, src),
            _ => None,
        };
        kept.extend(range.filter(|(from, to)| from < to));
    }
    // One inside another, or two that touch, are one.
    kept.sort_unstable();
    let mut merged: Vec<(usize, usize)> = Vec::new();
    for (from, to) in kept {
        match merged.last_mut() {
            Some(last) if from <= last.1 => last.1 = last.1.max(to),
            _ => merged.push((from, to)),
        }
    }
    merged
}

/// Whether an edit of `from..to` would change what one of `kept` holds.
///
/// An edit that ends where a stretch begins, or begins where it ends,
/// changes what stands beside it, and so does text put in at either end.
#[must_use]
pub fn touches(kept: &[(usize, usize)], from: usize, to: usize) -> bool {
    let i = kept.partition_point(|&(_, end)| end <= from);
    kept.get(i)
        .is_some_and(|&(start, _)| if from == to { start < from } else { start < to })
}

/// Whether the text at `at` is kept as written.
#[must_use]
pub fn holds(kept: &[(usize, usize)], at: usize) -> bool {
    touches(kept, at, at + 1)
}

#[cfg(test)]
mod tests {
    use super::*;
    use tree_sitter::Parser;

    /// What is kept of `src`, as text.
    fn kept(src: &str) -> Vec<&str> {
        let mut parser = Parser::new();
        parser.set_language(&crate::grammar::language()).unwrap();
        let tree = parser.parse(src, None).unwrap();
        assert!(!tree.root_node().has_error(), "{src}");
        kept_as_written(tree.root_node(), src.as_bytes())
            .into_iter()
            .map(|(from, to)| &src[from..to])
            .collect()
    }

    #[test]
    fn the_three_markers_are_read_and_nothing_else_is_one() {
        for (text, want) in [
            ("// fmt: off", Some(Marker::Off)),
            ("//fmt:on", Some(Marker::On)),
            ("//   fmt:   skip  ", Some(Marker::Skip)),
            ("// fmt: off, for now", None),
            ("// fmt off", None),
            ("// turn fmt: off", None),
            ("/// fmt: off", None),
        ] {
            assert!(marker(text.as_bytes()) == want, "{text}");
        }
    }

    #[test]
    fn a_region_runs_from_the_line_after_off_to_the_line_of_on() {
        assert_eq!(
            kept("a = 1;\n// fmt: off\nb  =  2;\n  c = 3;\n// fmt: on\nd = 4;\n"),
            ["\nb  =  2;\n  c = 3;\n"]
        );
        // With no `fmt: on` it runs to the end of the file, or of the
        // block it is in.
        assert_eq!(kept("a = 1;\n// fmt: off\nb  =  2;\n"), ["\nb  =  2;\n"]);
        assert_eq!(
            kept("f = {\n    // fmt: off\n    b  =  2;\n      c\n};\nd = 4;\n"),
            ["\n    b  =  2;\n      c\n"]
        );
        assert_eq!(
            kept("f = {\n    // fmt: off\n    b  =  2 };\nd = 4;\n"),
            ["\n    b  =  2 "]
        );
    }

    #[test]
    fn a_region_ends_at_an_on_of_its_own_depth_only() {
        // The `fmt: on` in the inner block is part of the region, and the
        // one after the block that holds the `fmt: off` ends nothing.
        assert_eq!(
            kept(
                "f = {\n    // fmt: off\n    g = {\n        // fmt: on\n        a\n    };\n    b\n};\n// fmt: on\nc = 1;\n"
            ),
            ["\n    g = {\n        // fmt: on\n        a\n    };\n    b\n"]
        );
        // A comment that ends a line of code begins no region.
        assert_eq!(kept("a = 1; // fmt: off\nb  =  2;\n"), Vec::<&str>::new());
    }

    #[test]
    fn skip_keeps_the_statement_it_trails_and_no_other() {
        assert_eq!(
            kept("a = 1;\nb  =  [1,2,   3]; // fmt: skip\nc = 3;\n"),
            ["b  =  [1,2,   3]; // fmt: skip"]
        );
        // All of its lines, when the comment stands in the middle of it.
        assert_eq!(
            kept("a = 1;\nb = foo(1,   2, // fmt: skip\n    3);\nc = 3;\n"),
            ["b = foo(1,   2, // fmt: skip\n    3);"]
        );
        // The innermost statement.
        assert_eq!(
            kept("f = { |x|\n    b  =  2; // fmt: skip\n    c\n};\n"),
            ["b  =  2; // fmt: skip"]
        );
        assert_eq!(
            kept("f = { |x| b  =  2 // fmt: skip\n};\n"),
            ["b  =  2 // fmt: skip"]
        );
        // A declaration and a method of a class.
        assert_eq!(
            kept(
                "Foo {\n    var a,   b; // fmt: skip\n    foo { ^a }\n    bar   { ^b } // fmt: skip\n}\n"
            ),
            ["var a,   b; // fmt: skip", "bar   { ^b } // fmt: skip"]
        );
        // On a line of its own it trails nothing.
        assert_eq!(kept("a = 1;\n// fmt: skip\nb = 2;\n"), Vec::<&str>::new());
    }

    /// `src` formatted, after checking that a second pass changes nothing.
    fn format(src: &str) -> String {
        let once = crate::format_source(src).unwrap();
        assert_eq!(crate::format_source(&once).unwrap(), once, "a second pass");
        once
    }

    #[test]
    fn a_region_in_a_block_is_left_as_written_and_the_code_around_it_is_formatted() {
        assert_eq!(
            format(
                "f = { |x|\n  var   a=1;\n  // fmt: off\n  var   b=2;   \n    y  =  [ 1,\n            2 ];\n      // fmt: on\n  z=y+1;\n  z };\n"
            ),
            "f = { |x|\n    var a = 1;\n    // fmt: off\n  var   b=2;   \n    y  =  [ 1,\n            2 ];\n    // fmt: on\n    z = y + 1;\n    z\n};\n"
        );
    }

    #[test]
    fn a_region_at_the_top_of_a_file_is_left_as_written() {
        assert_eq!(
            format("a=1;\n// fmt: off\nb  =  foo( 1,2 );  c=3;\n// fmt: on\nd=4;\n"),
            "a = 1;\n// fmt: off\nb  =  foo( 1,2 );  c=3;\n// fmt: on\nd = 4;\n"
        );
    }

    #[test]
    fn a_region_with_no_on_runs_to_the_end_of_its_block_or_of_the_file() {
        assert_eq!(
            format("f = {\n    a=1;\n    // fmt: off\n    b  =  2;\n      c=3\n};\nd=4;\n"),
            "f = {\n    a = 1;\n    // fmt: off\n    b  =  2;\n      c=3\n};\nd = 4;\n"
        );
        assert_eq!(
            format("a=1;\n// fmt: off\nb  =  2;\n\n\nc=3;   \n\n"),
            "a = 1;\n// fmt: off\nb  =  2;\n\n\nc=3;   \n\n"
        );
    }

    #[test]
    fn a_region_in_a_block_in_a_block_is_left_and_what_holds_it_is_open() {
        assert_eq!(
            format("f = { g = { |x|\n// fmt: off\n  x  =  x+1;\n// fmt: on\n  x }; g };\n"),
            "f = {\n    g = { |x|\n        // fmt: off\n  x  =  x+1;\n        // fmt: on\n        x\n    };\n    g\n};\n"
        );
    }

    #[test]
    fn a_table_aligned_by_hand_is_kept_byte_for_byte() {
        let table = "    var notes = [\n        60,  62,  64,\n        65,  67,  69,\n        71,  72\n    ];\n";
        let src = format!("f = {{\n    // fmt: off\n{table}    // fmt: on\n    notes\n}};\n");
        assert_eq!(format(&src), src);
        // Without the comments it is laid out like any array.
        assert_eq!(
            format(
                &src.replace("    // fmt: off\n", "")
                    .replace("    // fmt: on\n", "")
            ),
            "f = {\n    var notes = [60, 62, 64, 65, 67, 69, 71, 72];\n    notes\n};\n"
        );
    }

    #[test]
    fn a_comment_that_turns_the_formatter_off_is_not_filled_into_another() {
        let long = "word ".repeat(18);
        let src = format!("// {long}\n// fmt: off\na  =  1;\n// fmt: on\n// {long}\nb = 2;\n");
        let out = format(&src);
        assert!(
            out.contains("\n// fmt: off\na  =  1;\n// fmt: on\n"),
            "{out}"
        );
    }

    #[test]
    fn a_statement_that_skip_trails_is_left_as_written() {
        assert_eq!(
            format("a=1;\nm = [1,0,0,  0,1,0,  0,0,1]; // fmt: skip\nb=2;\n"),
            "a = 1;\nm = [1,0,0,  0,1,0,  0,0,1]; // fmt: skip\nb = 2;\n"
        );
        // All of its lines, where the comment stands in the middle of it,
        // and from where it begins, wherever that is on its line.
        assert_eq!(
            format("f = { a=1; m = foo(1,   2, // fmt: skip\n       3);\n  b=2 };\n"),
            "f = {\n    a = 1;\n    m = foo(1,   2, // fmt: skip\n       3);\n    b = 2\n};\n"
        );
        // The innermost statement only.
        assert_eq!(
            format("f = { |x| g = { y  =  x+1; // fmt: skip\n  y }; g  =  g+1; g };\n"),
            "f = { |x|\n    g = {\n        y  =  x+1; // fmt: skip\n        y\n    };\n    g = g + 1;\n    g\n};\n"
        );
        // A member of a class.
        assert_eq!(
            format(
                "Foo {\n  var a,   b; // fmt: skip\n  var   c;\n  foo   { ^a } // fmt: skip\n}\n"
            ),
            "Foo {\n    var a,   b; // fmt: skip\n    var c;\n    foo   { ^a } // fmt: skip\n}\n"
        );
    }

    #[test]
    fn an_edit_touches_what_is_kept_when_it_would_change_it() {
        let kept = [(10, 20)];
        for (from, to, want) in [
            (0, 10, false),
            (5, 11, true),
            (10, 10, false),
            (11, 11, true),
            (12, 15, true),
            (19, 25, true),
            (20, 20, false),
            (20, 25, false),
        ] {
            assert_eq!(touches(&kept, from, to), want, "{from}..{to}");
        }
    }
}
