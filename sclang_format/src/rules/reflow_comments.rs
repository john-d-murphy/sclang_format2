use crate::engine::as_written::marker;
use crate::engine::layout::{LineCursor, columns};
use crate::engine::text::is_space;
use crate::engine::{Ctx, IndentStyle, TextEdit};
use crate::grammar;
use crate::rules::Rule;
use anyhow::Result;
use std::ops::Range;
use tree_sitter::Parser;

/// Fills a paragraph of `//` comments again when one of its lines is too
/// wide, from that line to the paragraph's end.
///
/// Only comments that have their lines to themselves, and only where a line
/// overflows: a paragraph whose lines all fit is left as its writer broke
/// it. A paragraph is a run of comment lines with the same indent, the same
/// slashes and the same blanks after them. An empty comment line ends it,
/// and so does a line that stands further in than the others (a code
/// sample, a diagram, a table), which is never touched. A list item (`-`,
/// `*`, `1.`) begins a paragraph of its own, whose later lines hang under
/// its text. Commented-out code is left alone.
///
/// It runs once `indent_by_ast_level` has run, so that a line is measured
/// as it stands and the lines it writes take the indent of the one they
/// come from.
pub struct ReflowComments;

impl Rule for ReflowComments {
    fn name(&self) -> &'static str {
        "reflow_comments"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let edits = collect(cx);
        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

/// An edit for each paragraph that has a line too wide.
fn collect(cx: &Ctx) -> Vec<TextEdit> {
    let style = cx.indent_style;
    let lines = comment_lines(cx);
    let mut edits = Vec::new();
    // Made when the first block is found that needs one.
    let mut parser = None;

    // A block is a run of comment lines one under the other, with the same
    // indent and the same slashes.
    let mut from = 0;
    while from < lines.len() {
        let mut to = from + 1;
        while to < lines.len()
            && lines[to].start == lines[to - 1].end + 1
            && lines[to].indent == lines[from].indent
            && lines[to].slashes == lines[from].slashes
        {
            to += 1;
        }
        let block = &lines[from..to];
        from = to;
        if !block
            .iter()
            .any(|line| line.overflows(style, cx.line_width))
        {
            continue;
        }
        let parser = parser.get_or_insert_with(|| {
            let mut parser = Parser::new();
            parser
                .set_language(&grammar::language())
                .expect("the grammar the text was parsed with");
            parser
        });
        for paragraph in paragraphs(block, parser) {
            let lines = &block[paragraph.lines];
            refill(lines, &paragraph.hang, style, cx.line_width, &mut edits);
        }
    }
    edits
}

/// A `//` comment that has its line to itself.
struct Line<'a> {
    /// Where the line begins, and where it ends: at its line break.
    start: usize,
    end: usize,
    indent: &'a str,
    slashes: &'a str,
    /// The blanks between the slashes and the text.
    space: &'a str,
    /// What the comment says, without the blanks that end the line.
    text: &'a str,
}

impl Line<'_> {
    fn prefix(&self) -> String {
        format!("{}{}{}", self.indent, self.slashes, self.space)
    }

    /// Whether the line is too wide and could be less so: a line that is
    /// one word, or a list item's mark and one word, cannot be broken, and
    /// is not counted as overflowing, or it would be filled again on every
    /// pass.
    fn overflows(&self, style: IndentStyle, line_width: usize) -> bool {
        let width = columns(self.prefix().as_bytes(), style) + columns(self.text.as_bytes(), style);
        width > line_width && units(&[self]).len() > 1
    }
}

/// The `//` comments of the text that have their lines to themselves, in
/// order.
fn comment_lines(cx: &Ctx) -> Vec<Line<'_>> {
    let bytes = cx.bytes();
    let root = cx.tree.root_node();
    let text = |range: Range<usize>| std::str::from_utf8(&bytes[range]).unwrap_or_default();
    LineCursor::new(bytes)
        .filter(|line| {
            // The slashes of a string or of a block comment are no comment.
            bytes[line.first_non_ws..line.end].starts_with(b"//")
                && root
                    .descendant_for_byte_range(line.first_non_ws, line.first_non_ws + 1)
                    .is_some_and(|n| {
                        n.kind() == "line_comment" && n.start_byte() == line.first_non_ws
                    })
        })
        .map(|line| {
            let count = |from: usize, is: fn(u8) -> bool| {
                bytes[from..line.end].iter().take_while(|&&b| is(b)).count()
            };
            let slashes = line.first_non_ws + count(line.first_non_ws, |b| b == b'/');
            let space = slashes + count(slashes, is_space);
            Line {
                start: line.start,
                end: line.end,
                indent: text(line.start..line.first_non_ws),
                slashes: text(line.first_non_ws..slashes),
                space: text(slashes..space),
                text: text(space..line.end).trim_end_matches([' ', '\t', '\r']),
            }
        })
        .collect()
}

/// A paragraph: its lines, as a range of its block's, and the blanks that
/// stand between the slashes and the text of a line the paragraph is
/// continued on.
struct Paragraph {
    lines: Range<usize>,
    hang: String,
}

/// The paragraphs of a block.
///
/// The lines of a block that stand furthest out say where its paragraphs
/// stand. A paragraph ends before an empty line, before a line that stands
/// further in (unless it hangs under the text of the list item the
/// paragraph is), before a list item, and before commented-out code.
fn paragraphs(block: &[Line], parser: &mut Parser) -> Vec<Paragraph> {
    let Some(base) = block
        .iter()
        .filter(|line| !line.text.is_empty())
        .map(|line| line.space)
        .min_by_key(|space| space.len())
    else {
        return Vec::new();
    };
    let code = commented_out_code(block, parser);

    let mut paragraphs: Vec<Paragraph> = Vec::new();
    // Whether the last paragraph can take the next line.
    let mut open = false;
    for (i, line) in block.iter().enumerate() {
        // A comment that turns the formatter off or on keeps its line.
        let is_marker = marker(format!("//{}", line.text).as_bytes()).is_some();
        if line.text.is_empty() || code[i] || is_marker {
            open = false;
            continue;
        }
        let item = list_mark(line.text).filter(|_| line.space == base);
        let continues = open
            && item.is_none()
            && paragraphs
                .last()
                .is_some_and(|p| line.space == base || line.space == p.hang);
        if continues {
            paragraphs.last_mut().expect("an open paragraph").lines.end = i + 1;
        } else if line.space == base {
            paragraphs.push(Paragraph {
                lines: i..i + 1,
                hang: format!("{base}{}", " ".repeat(item.unwrap_or(0))),
            });
            open = true;
        } else {
            open = false;
        }
    }
    paragraphs
}

/// For each line of a block, whether it is commented-out code: it parses as
/// `SuperCollider`, alone or together with the lines around it up to the
/// nearest empty ones, and is more than one token. (A sentence of two words
/// or more does not parse. A single name, number or string does, and is as
/// likely to be a word of prose.)
fn commented_out_code(block: &[Line], parser: &mut Parser) -> Vec<bool> {
    let mut is_code = |text: &str| {
        parser.parse(text, None).is_some_and(|tree| {
            let root = tree.root_node();
            let mut node = root;
            while node.child_count() == 1 {
                node = node.child(0).expect("the one child");
            }
            !root.has_error() && node.child_count() > 1 && node.kind() != "string"
        })
    };
    let mut code = vec![false; block.len()];
    let mut from = 0;
    while from < block.len() {
        let mut to = from;
        while to < block.len() && !block[to].text.is_empty() {
            to += 1;
        }
        let together: Vec<&str> = block[from..to].iter().map(|line| line.text).collect();
        if to > from && is_code(&together.join("\n")) {
            code[from..to].fill(true);
        } else {
            for (code, line) in code[from..to].iter_mut().zip(&block[from..to]) {
                *code = is_code(line.text);
            }
        }
        from = to + 1;
    }
    code
}

/// The length of the mark a list item begins with and of the blanks after
/// it (`- `, `* `, `12. `), when `text` is a list item.
fn list_mark(text: &str) -> Option<usize> {
    let word = text.split([' ', '\t']).next().unwrap_or_default();
    let blanks = text[word.len()..]
        .bytes()
        .take_while(|&b| is_space(b))
        .count();
    (is_list_mark(word) && blanks > 0).then_some(word.len() + blanks)
}

/// Whether `word` is what a list item begins with: `-`, `*`, `+`, or a
/// number and `.` or `)`.
fn is_list_mark(word: &str) -> bool {
    matches!(word, "-" | "*" | "+")
        || word
            .strip_suffix(['.', ')'])
            .is_some_and(|n| !n.is_empty() && n.bytes().all(|b| b.is_ascii_digit()))
}

/// What a line is filled with: a word, with the blanks that stood before it
/// when it was not the first of its line.
struct Unit<'a> {
    blanks: &'a str,
    text: String,
}

/// The words of `lines`, in order. A word that reads as a list item's mark
/// is one unit with the word after it when it begins the lines, and with
/// the word before it anywhere else: put first on a line by the filling, it
/// would begin a list item there on the next pass.
fn units<'a>(lines: &[&Line<'a>]) -> Vec<Unit<'a>> {
    let mut units: Vec<Unit> = Vec::new();
    // Whether the next word joins the mark that begins the lines.
    let mut joins = false;
    for line in lines {
        let mut rest = line.text;
        let mut blanks = if units.is_empty() { "" } else { " " };
        while !rest.is_empty() {
            let word = rest.split([' ', '\t']).next().unwrap_or_default();
            let mark = is_list_mark(word);
            match units.last_mut() {
                Some(last) if joins || mark => {
                    last.text.push_str(blanks);
                    last.text.push_str(word);
                    joins = false;
                }
                Some(_) => units.push(Unit {
                    blanks,
                    text: word.to_string(),
                }),
                None => {
                    units.push(Unit {
                        blanks,
                        text: word.to_string(),
                    });
                    joins = mark;
                }
            }
            rest = &rest[word.len()..];
            let after = rest.bytes().take_while(|&b| is_space(b)).count();
            blanks = &rest[..after];
            rest = &rest[after..];
        }
    }
    units
}

/// Fills a paragraph again from its first line that overflows to its end,
/// with as many words to a line as fit, breaking only where a blank stood.
/// A word too long for a line gets a line to itself.
fn refill(
    paragraph: &[Line],
    hang: &str,
    style: IndentStyle,
    line_width: usize,
    edits: &mut Vec<TextEdit>,
) {
    let overflows = |line: &Line| line.overflows(style, line_width);
    let Some(first) = paragraph.iter().position(overflows) else {
        return;
    };
    let lines: Vec<&Line> = paragraph[first..].iter().collect();
    let hanging = format!("{}{}{hang}", lines[0].indent, lines[0].slashes);
    let width = |text: &str| columns(text.as_bytes(), style);

    let mut filled = lines[0].prefix();
    let mut used = width(&filled);
    let mut begins_line = true;
    for unit in units(&lines) {
        let more = width(unit.blanks) + width(&unit.text);
        if !begins_line && used + more > line_width {
            filled.push('\n');
            filled.push_str(&hanging);
            used = width(&hanging);
            begins_line = true;
        }
        if !begins_line {
            filled.push_str(unit.blanks);
            used += width(unit.blanks);
        }
        filled.push_str(&unit.text);
        used += width(&unit.text);
        begins_line = false;
    }
    edits.push(TextEdit {
        start_byte: lines[0].start,
        end_byte: lines[lines.len() - 1].end,
        replacement: filled,
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    fn format_with(src: &str, style: IndentStyle) -> String {
        let mut cx = Ctx::new(src.to_string(), &grammar::language(), style).unwrap();
        ReflowComments.run(&mut cx).unwrap();
        cx.to_string()
    }

    /// `src` with its comments filled, after checking that no word of it
    /// was lost or moved and that a second pass changes nothing.
    fn format(src: &str) -> String {
        let once = format_with(src, IndentStyle::Spaces { width: 4 });
        let said = |text: &str| -> Vec<String> {
            text.split_whitespace()
                .filter(|word| !word.bytes().all(|b| b == b'/'))
                .map(str::to_string)
                .collect()
        };
        assert_eq!(said(&once), said(src));
        assert_eq!(format_with(&once, IndentStyle::Spaces { width: 4 }), once);
        once
    }

    /// `n` words of four letters: 5n - 1 columns.
    fn words(n: usize) -> String {
        vec!["word"; n].join(" ")
    }

    #[test]
    fn test_a_paragraph_is_filled_again_from_its_first_line_too_wide() {
        // The second line is 102 wide. 15 words fill a line to 77; the five
        // left over take the words of the line after with them.
        let src = format!("// a short line\n// {}\n// {}\n", words(20), words(3));
        assert_eq!(
            format(&src),
            format!("// a short line\n// {}\n// {}\n", words(15), words(8))
        );
    }

    #[test]
    fn test_a_paragraph_whose_lines_all_fit_is_left_as_it_is() {
        // Short lines the writer broke, and one of exactly 80.
        let src = format!("// one\n// two\n// {} ab\n// three\n", words(15));
        assert_eq!(src.lines().nth(2).unwrap().len(), 80);
        assert_eq!(format(&src), src);
    }

    #[test]
    fn test_a_line_of_81_is_too_wide() {
        let src = format!("// {} abc\n", words(15));
        assert_eq!(format(&src), format!("// {}\n// abc\n", words(15)));
    }

    #[test]
    fn test_the_width_is_counted_in_characters() {
        // 80 columns in 82 bytes.
        let src = format!("// {} éé\n", words(15));
        assert_eq!(format(&src), src);
        let src = format!("// {} ééé\n", words(15));
        assert_eq!(format(&src), format!("// {}\n// ééé\n", words(15)));
    }

    #[test]
    fn test_an_empty_comment_line_ends_a_paragraph() {
        let src = format!("// {}\n//\n// {}\n", words(20), words(3));
        assert_eq!(
            format(&src),
            format!("// {}\n// {}\n//\n// {}\n", words(15), words(5), words(3))
        );
    }

    #[test]
    fn test_the_lines_of_a_list_item_hang_under_its_text() {
        let src = format!("// - {}\n// - short\n", words(20));
        assert_eq!(
            format(&src),
            format!("// - {}\n//   {}\n// - short\n", words(15), words(5))
        );
        let src = format!("// 12. {}\n// 13. short\n", words(20));
        assert_eq!(
            format(&src),
            format!("// 12. {}\n//     {}\n// 13. short\n", words(14), words(6))
        );
    }

    #[test]
    fn test_a_list_item_takes_the_lines_that_hang_under_it() {
        let src = format!("// - {}\n//   {}\n// - next\n", words(20), words(3));
        assert_eq!(
            format(&src),
            format!("// - {}\n//   {}\n// - next\n", words(15), words(8))
        );
        // A list item is not filled into the paragraph before it.
        let src = format!("// {}\n// - an item\n", words(20));
        assert_eq!(
            format(&src),
            format!("// {}\n// {}\n// - an item\n", words(15), words(5))
        );
    }

    #[test]
    fn test_a_line_that_stands_further_in_is_never_touched() {
        let sample = format!("//     {}", words(20));
        let src = format!("// {}\n{sample}\n// {}\n", words(20), words(20));
        let filled = format!("// {}\n// {}\n", words(15), words(5));
        assert_eq!(format(&src), format!("{filled}{sample}\n{filled}"));
    }

    #[test]
    fn test_commented_out_code_is_left_alone() {
        // A line that parses alone; lines that parse together; and a line
        // of code between two of prose, which do not take it in.
        let code =
            "// x = foo.bar(1, 2, 3) + baz.qux(4, 5, 6) + SinOsc.ar(440, 0, 0.1) * Env.perc.kr(2);";
        assert!(code.len() > 80);
        assert_eq!(format(code), code);
        let src = "// SynthDef(\\name, { |out = 0, freq = 440, amp = 0.1, gate = 1, pan = 0, attack = 0.01|\n// Out.ar(out, SinOsc.ar(freq));\n// }).add;\n";
        assert_eq!(format(src), src);
        let src = format!("// {}\n{code}\n// {}\n", words(20), words(20));
        let filled = format!("// {}\n// {}\n", words(15), words(5));
        assert_eq!(format(&src), format!("{filled}{code}\n{filled}"));
    }

    #[test]
    fn test_a_sentence_is_no_code_though_a_word_of_it_parses() {
        // A string alone on its line parses, and is a quoted sentence.
        let src = format!("// \"{}\"\n", words(20));
        assert_eq!(
            format(&src),
            format!("// \"{}\n// {}\"\n", words(15), words(5))
        );
    }

    #[test]
    fn test_a_word_too_long_for_a_line_gets_a_line_to_itself() {
        let long = "x".repeat(90);
        let src = format!("// see {long} for more\n");
        assert_eq!(format(&src), format!("// see\n// {long}\n// for more\n"));
        // Alone on its line it cannot be helped, and nothing is done.
        let src = format!("// before\n// {long}\n// after\n// - {long}\n");
        assert_eq!(format(&src), src);
    }

    #[test]
    fn test_no_line_is_broken_before_what_reads_as_a_list_mark() {
        // Broken before the dash, the second line would be a list item.
        let src = format!("// {} - word word\n", words(15));
        assert_eq!(format(&src), format!("// {} -\n// word word\n", words(15)));
    }

    #[test]
    fn test_the_blanks_between_two_words_that_stay_together_are_kept() {
        let src = format!("// word.  {}\n", words(19));
        assert_eq!(
            format(&src),
            format!("// word.  {}\n// {}\n", words(14), words(5))
        );
    }

    #[test]
    fn test_the_filled_lines_take_the_indent_and_the_slashes_of_the_first() {
        let src = format!("f = {{\n    // {}\n    1\n}};\n", words(20));
        assert_eq!(
            format(&src),
            format!(
                "f = {{\n    // {}\n    // {}\n    1\n}};\n",
                words(14),
                words(6)
            )
        );
        let src = format!("/// {}\n", words(20));
        assert_eq!(
            format(&src),
            format!("/// {}\n/// {}\n", words(15), words(5))
        );
        // A tab of indent is four columns.
        let src = format!("f = {{\n\t// {}\n\t1\n}};\n", words(20));
        assert_eq!(
            format_with(&src, IndentStyle::Tabs),
            format!("f = {{\n\t// {}\n\t// {}\n\t1\n}};\n", words(14), words(6))
        );
    }

    #[test]
    fn test_other_comments_and_strings_are_left_alone() {
        for src in [
            format!("x = 1; // {}\n", words(20)),
            format!("/* {} */\n", words(20)),
            format!("/*\n// {}\n*/\n", words(20)),
            format!("x = \"\n// {}\n\";\n", words(20)),
        ] {
            assert_eq!(format(&src), src);
        }
    }
}
