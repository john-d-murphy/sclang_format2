//! A file of regions.
//!
//! Much code for sclang is written as a document and not as one program:
//! stretches of code, each in parentheses of its own, to be evaluated one at
//! a time from the editor. sclang refuses such a file read whole, at the
//! second `(`. Each region is a program, and is formatted as one.

use anyhow::{Result, bail};
use std::ops::Range;

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

/// Whether no token stands between `from` and the end of its line, or the
/// first that does is a `;`.
fn ends_its_line(bytes: &[u8], mut from: usize) -> bool {
    loop {
        match bytes.get(from) {
            None | Some(b'\n' | b';') => return true,
            Some(b' ' | b'\t' | b'\r') => from += 1,
            Some(_) => match not_code(bytes, from) {
                Some(end) if bytes[from] == b'/' => from = end,
                _ => return false,
            },
        }
    }
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
