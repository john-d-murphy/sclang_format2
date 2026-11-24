//! A file of regions.
//!
//! Much code for sclang is written as a document and not as one program:
//! stretches of code, each in parentheses of its own, to be evaluated one at
//! a time from the editor. sclang refuses such a file read whole, at the
//! second `(`. Each region is a program, and is formatted as one.
//!
//! The lines between two regions are loose code, evaluated a line or a
//! selection at a time. Where they are a program they are formatted as one.
//! Often they are not (`x = Synth(\a)` and under it `x.free`, with no
//! semicolon), and then they are left as they are written.

use crate::grammar;
use anyhow::{Result, bail};
use std::ops::Range;
use tree_sitter::Parser;

/// The regions of `src`, each from its `(` to its `)`.
///
/// A region is what the IDE takes for one (`bracketPairDefinesRegion` in
/// editors/sc-ide/widgets/code_editor/sc_editor.cpp): a pair of brackets
/// inside no other, whose `(` is the first character of its line, and whose
/// `)` is the last token of its line or stands before a `;`.
///
/// # Errors
/// When a bracket is never closed, or closes what never opened: the regions
/// of such a text cannot be told.
pub fn of(src: &str) -> Result<Vec<Range<usize>>> {
    let bytes = src.as_bytes();
    let line = |at: usize| src[..at].matches('\n').count() + 1;
    let mut found = Vec::new();
    // How many brackets are open, and where the outermost of them opened.
    let (mut depth, mut opened) = (0usize, 0);
    let mut i = 0;
    while i < bytes.len() {
        if let Some(end) = not_code(bytes, i) {
            i = end;
            continue;
        }
        match bytes[i] {
            b'(' | b'[' | b'{' => {
                if depth == 0 {
                    opened = i;
                }
                depth += 1;
            }
            b')' | b']' | b'}' => {
                if depth == 0 {
                    bail!("line {} closes a bracket that was never opened", line(i));
                }
                depth -= 1;
                if depth == 0
                    && bytes[opened] == b'('
                    && bytes[i] == b')'
                    && (opened == 0 || bytes[opened - 1] == b'\n')
                    && ends_its_line(bytes, i + 1)
                {
                    found.push(opened..i + 1);
                }
            }
            _ => {}
        }
        i += 1;
    }
    if depth > 0 {
        bail!(
            "the bracket opened at line {} is never closed",
            line(opened)
        );
    }
    Ok(found)
}

/// Where the comment, string, symbol or character that begins at `at` ends;
/// `None` where none begins. A bracket inside one is not a bracket.
fn not_code(bytes: &[u8], at: usize) -> Option<usize> {
    let quoted = |quote: u8| {
        let mut i = at + 1;
        while i < bytes.len() && bytes[i] != quote {
            i += if bytes[i] == b'\\' { 2 } else { 1 };
        }
        (i + 1).min(bytes.len())
    };
    match (bytes[at], bytes.get(at + 1)) {
        (b'/', Some(b'/')) => Some(
            bytes[at..]
                .iter()
                .position(|&b| b == b'\n')
                .map_or(bytes.len(), |n| at + n),
        ),
        // A block comment may hold another.
        (b'/', Some(b'*')) => {
            let (mut depth, mut i) = (1, at + 2);
            while depth > 0 && i < bytes.len() {
                match &bytes[i..(i + 2).min(bytes.len())] {
                    b"/*" => (depth, i) = (depth + 1, i + 2),
                    b"*/" => (depth, i) = (depth - 1, i + 2),
                    _ => i += 1,
                }
            }
            Some(i)
        }
        (b'"' | b'\'', _) => Some(quoted(bytes[at])),
        (b'$', Some(b'\\')) => Some((at + 3).min(bytes.len())),
        (b'$', Some(_)) => Some(at + 2),
        _ => None,
    }
}

/// Where the line that `from` stands in ends, its line break with it. A line
/// break inside a comment or a string does not end it.
pub fn line_end(src: &str, mut from: usize) -> usize {
    let bytes = src.as_bytes();
    while from < bytes.len() {
        if bytes[from] == b'\n' {
            return from + 1;
        }
        from = not_code(bytes, from).unwrap_or(from + 1);
    }
    bytes.len()
}

/// Whether no token stands between `from` and the end of its line, or the
/// first that does is a `;`.
fn ends_its_line(bytes: &[u8], mut from: usize) -> bool {
    loop {
        match bytes.get(from) {
            None | Some(b'\n' | b';') => return true,
            Some(b' ' | b'\t' | b'\r') => from += 1,
            Some(_) => match not_code(bytes, from) {
                // A comment that runs past the line ends it.
                Some(end) if bytes[from] == b'/' => {
                    if bytes[from..end].contains(&b'\n') {
                        return true;
                    }
                    from = end;
                }
                _ => return false,
            },
        }
    }
}

/// Whether `code`, which parses, may be lines written to be evaluated one at
/// a time: a statement of it runs over several lines, and each of those
/// lines is a program too. `a = 5` and `-3.postln` are two programs, and
/// another one together.
///
/// # Errors
/// When the grammar cannot be loaded.
pub fn reads_two_ways(code: &str) -> Result<bool> {
    let mut parser = Parser::new();
    parser.set_language(&grammar::language())?;
    let mut parsed = |text: &str| {
        parser
            .parse(text, None)
            .filter(|tree| !tree.root_node().has_error())
    };
    let Some(tree) = parsed(code) else {
        return Ok(false);
    };
    let lines: Vec<&str> = code.lines().collect();
    let root = tree.root_node();
    let mut cursor = root.walk();
    Ok(root
        .named_children(&mut cursor)
        .filter(|node| !node.kind().ends_with("comment"))
        .map(|node| node.start_position().row..=node.end_position().row)
        .any(|rows| {
            // A line that is indented goes on from the line before it.
            rows.start() != rows.end()
                && lines[rows]
                    .iter()
                    .all(|line| !line.starts_with([' ', '\t']) && parsed(line).is_some())
        }))
}

/// Whether loose `code` is a program to format, compile or evaluate whole:
/// it parses, and its lines are not lines to evaluate one at a time.
///
/// # Errors
/// When the grammar cannot be loaded.
pub fn is_program(code: &str) -> Result<bool> {
    let mut parser = Parser::new();
    parser.set_language(&grammar::language())?;
    let sound = parser
        .parse(code, None)
        .is_some_and(|tree| !tree.root_node().has_error());
    Ok(!code.trim().is_empty() && sound && !reads_two_ways(code)?)
}

/// A part of a file of regions. The parts, in order, are the file.
pub enum Part {
    /// A region, from its `(` to its `)`.
    Region(Range<usize>),
    /// Loose code with the blank lines around it, and whether its code is a
    /// program (`is_program`).
    Loose { text: Range<usize>, program: bool },
    /// What is left as it is written: blank lines, and what shares the line
    /// of a region's `)`.
    AsWritten(Range<usize>),
}

/// `src` in its parts, given its regions (`of`). The lines between two
/// regions are one loose part if they are a program whole, and if not, one
/// for each paragraph of them.
///
/// # Errors
/// When the grammar cannot be loaded.
pub fn parts(src: &str, regions: &[Range<usize>]) -> Result<Vec<Part>> {
    let loose = |from: usize, to: usize, parts: &mut Vec<Part>| -> Result<()> {
        if is_program(&src[from..to])? {
            parts.push(Part::Loose {
                text: from..to,
                program: true,
            });
            return Ok(());
        }
        let mut at = from;
        for paragraph in paragraphs(&src[from..to]) {
            let text = at..at + paragraph.len();
            at = text.end;
            parts.push(if paragraph.trim().is_empty() {
                Part::AsWritten(text)
            } else {
                Part::Loose {
                    text,
                    program: is_program(paragraph)?,
                }
            });
        }
        Ok(())
    };
    let mut parts = Vec::new();
    let mut done = 0;
    for region in regions {
        loose(done, region.start, &mut parts)?;
        parts.push(Part::Region(region.clone()));
        done = line_end(src, region.end);
        parts.push(Part::AsWritten(region.end..done));
    }
    loose(done, src.len(), &mut parts)?;
    Ok(parts)
}

/// `text` in paragraphs, which together are `text`: each runs to the end of
/// the blank lines after it. A blank line inside a comment or a string
/// parts nothing.
pub fn paragraphs(text: &str) -> Vec<&str> {
    let mut found = Vec::new();
    // Where the paragraph and the line begin, and whether the line before
    // was blank.
    let (mut paragraph, mut line, mut after_blank) = (0, 0, false);
    while line < text.len() {
        let end = line_end(text, line);
        let blank = text[line..end].trim().is_empty();
        if after_blank && !blank {
            found.push(&text[paragraph..line]);
            paragraph = line;
        }
        after_blank = blank;
        line = end;
    }
    found.push(&text[paragraph..]);
    found
}

#[cfg(test)]
mod tests {
    use super::of;
    use crate::format_source;

    fn regions(src: &str) -> Vec<&str> {
        of(src).unwrap().into_iter().map(|r| &src[r]).collect()
    }

    #[test]
    fn test_a_region_is_a_pair_inside_no_other_whose_paren_begins_a_line() {
        for (src, want) in [
            ("(\na;\n)\n\n(\nb;\n)\n", vec!["(\na;\n)", "(\nb;\n)"]),
            // The `)` before a `;`, a comment, or blanks.
            (
                "(\na;\n);\n(\nb;\n) // c\n(\nc;\n)  \n",
                vec!["(\na;\n)", "(\nb;\n)", "(\nc;\n)"],
            ),
            // A `(` that begins a line inside a region opens no region.
            (
                "(\nf = {\n(\na;\n)\n};\n)\n",
                vec!["(\nf = {\n(\na;\n)\n};\n)"],
            ),
            // Not the first character of its line.
            (" (\na;\n)\n", vec![]),
            // More code after the `)`.
            ("(\na: 1\n).play;\n(1 + 2).postln;\n", vec![]),
            // Other brackets.
            ("[\na\n]\n{\nb\n}\n", vec![]),
            // A bracket in a comment, a string, a symbol or a character is
            // not a bracket.
            (
                "// (\n/* ( /* ( */ ( */\n\"(\\\"(\";\n'(\\'(';\n$(;\n$\\(;\n(\na;\n)\n",
                vec!["(\na;\n)"],
            ),
            (
                "(\n\")\";\n// )\n$);\n')';\n)\n",
                vec!["(\n\")\";\n// )\n$);\n')';\n)"],
            ),
        ] {
            assert_eq!(regions(src), want, "{src:?}");
        }
    }

    #[test]
    fn test_a_bracket_without_its_other_is_refused_with_its_line() {
        for (src, line) in [
            ("(\na;\n)\n\n(\nb;\n", "line 5"),
            ("(\na;\n)\n]\n", "line 4"),
        ] {
            let refused = format!("{:#}", format_source(src).unwrap_err());
            assert!(refused.contains(line), "{src:?}: {refused}");
        }
    }

    #[test]
    fn test_each_region_formats_as_it_would_alone_and_the_rest_is_left() {
        let first = "(\nvar a=1;\na.postln;\n)";
        let second = "(\nvar b=[1,2];\nb.do{|x|x.postln};\n)";
        let alone = |region| format_source(region).unwrap().trim_end().to_string();
        assert_ne!(alone(first), first);
        assert_ne!(alone(second), second);

        let file =
            |a: &str, b: &str| format!("// one\n{a}\n\nx.free\ny=1 ;\n// two\n{b} // after\n");
        let formatted = format_source(&file(first, second)).unwrap();
        assert_eq!(formatted, file(&alone(first), &alone(second)));
        assert_eq!(format_source(&formatted).unwrap(), formatted);
    }

    const REGION: &str = "(\nvar a=1;\na.postln;\n)";

    fn region_formatted() -> String {
        format_source(REGION).unwrap().trim_end().to_string()
    }

    #[test]
    fn test_loose_code_that_is_a_program_is_formatted_as_one() {
        let file = |region: &str, first: &str, second: &str, last: &str| {
            format!("{first}\n\n{region} // c\n\n{second}\n\n\n{region};\n{last}\n")
        };
        let src = file(
            REGION,
            "s.boot ;",
            "  x=Synth(\\ping,[freq:440]);\nx.free ;  ",
            "y=1 ;",
        );
        let want = file(
            &region_formatted(),
            "s.boot;",
            "x = Synth(\\ping, [freq: 440]);\nx.free;",
            "y = 1;",
        );
        assert_eq!(format_source(&src).unwrap(), want);
        assert_eq!(format_source(&want).unwrap(), want);
    }

    #[test]
    fn test_what_shares_the_line_of_the_closing_paren_is_left() {
        // The comment that begins on that line ends on the next, and what
        // follows it there is part of no loose program.
        let file = |region: &str, loose: &str| {
            format!("{region} /* note\nx */ y=1 ;\n{loose}\n{region}\n")
        };
        assert_eq!(
            format_source(&file(REGION, "z=2 ;")).unwrap(),
            file(&region_formatted(), "z = 2;")
        );
    }

    /// One paragraph that is no program does not keep the paragraphs around
    /// it from being formatted. A blank line inside a comment parts nothing.
    #[test]
    fn test_loose_code_is_formatted_a_paragraph_at_a_time_where_it_is_no_program_whole() {
        let file = |region: &str, tidy: &str, commented: &str| {
            format!("{tidy}\n\nx=Synth(\\ping)\nx.free ;\n\n\n{commented}\n{region}\n\n{region}\n")
        };
        let src = file(REGION, "  y=1 ;\nz=2 ;", "/* a\n\nb=1 ; */\nc=3 ;");
        let want = file(
            &region_formatted(),
            "y = 1;\nz = 2;",
            "/* a\n\nb=1 ; */\nc = 3;",
        );
        assert_eq!(format_source(&src).unwrap(), want);
        assert_eq!(format_source(&want).unwrap(), want);
    }

    /// The formatter's own broken lines are not lines to evaluate one at a
    /// time, though each may parse alone: the later ones are indented.
    #[test]
    fn test_only_lines_that_begin_in_the_first_column_are_lines_of_their_own() {
        assert!(super::reads_two_ways("a = b\n- c;").unwrap());
        assert!(!super::reads_two_ways("a = b\n    - c;").unwrap());
        assert!(!super::reads_two_ways("a = b - c;\nd = 1;").unwrap());
    }

    /// Lines written to be evaluated one at a time may parse together as
    /// something else: `x.play` and `(1..3).do { ... }` as one call. Joined,
    /// they would no longer be two lines to evaluate. They are left.
    #[test]
    fn test_loose_lines_that_read_another_way_together_are_left() {
        for loose in [
            "a=5\n-3.postln",
            "x.play\n(1..3).do{|i|i.postln}",
            "a=[1,2,3]\n[0].postln",
        ] {
            let file = |region: &str| format!("{loose}\n{region}\n\n{region}\n");
            assert_eq!(
                format_source(&file(REGION)).unwrap(),
                file(&region_formatted()),
                "{loose:?}"
            );
        }
    }

    #[test]
    fn test_the_units_of_a_file() {
        let kinds = |src: &str| -> Vec<(&str, bool, (usize, usize))> {
            crate::units(src)
                .unwrap()
                .iter()
                .map(|unit| (unit.kind.name(), unit.program, unit.lines))
                .collect()
        };
        // One program, parsing or not.
        assert_eq!(kinds("x = 1;\ny = 2;\n"), [("program", true, (1, 2))]);
        assert_eq!(kinds("x = 1;\ny = = 2;\n"), [("program", false, (1, 2))]);
        // Regions and loose code.
        let src = "s.boot;\n\n(\na;\n) // c\n\nx=Synth(\\p)\nx.free ;\n\ny=1 ;\n(\nb;\n)\n";
        assert_eq!(
            kinds(src),
            [
                ("loose", true, (1, 1)),
                ("region", true, (3, 5)),
                ("loose", false, (7, 8)),
                ("loose", true, (10, 10)),
                ("region", true, (11, 13)),
            ]
        );
        // A file with a region is told by its regions though it parses
        // whole: sclang refuses `var` in parentheses that follow a
        // statement, and takes each such region only by itself.
        assert_eq!(
            kinds("s.boot;\n\n(\nvar a = 1;\na.postln;\n)\n"),
            [("loose", true, (1, 1)), ("region", true, (3, 6))]
        );
        // The bytes of a unit are its code.
        let units = crate::units(src).unwrap();
        assert_eq!(&src[units[1].bytes.clone()], "(\na;\n)");
        assert_eq!(&src[units[2].bytes.clone()], "x=Synth(\\p)\nx.free ;");
    }

    #[test]
    fn test_units_cannot_be_told_with_a_bracket_left_open() {
        let refused = format!("{:#}", crate::units("(\na;\n)\n\n(\nb;\n").unwrap_err());
        assert!(refused.contains("line 5"), "{refused}");
    }

    #[test]
    fn test_a_region_that_does_not_parse_is_refused_with_its_line_in_the_file() {
        let src = "(\nvar a = 1;\n)\n\n(\nvar b = 2;\nb = = 3;\n)\n";
        let refused = format!("{:#}", format_source(src).unwrap_err());
        assert!(refused.contains("line 7"), "{refused}");
    }

    #[test]
    fn test_text_that_is_no_program_and_has_no_region_is_refused_with_its_line() {
        let refused = format!("{:#}", format_source("x = 1;\ny = = 2;\n").unwrap_err());
        assert!(refused.contains("line 2"), "{refused}");
    }
}
