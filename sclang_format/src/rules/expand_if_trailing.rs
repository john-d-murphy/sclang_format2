use crate::engine::text::{is_newline, is_space};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use crate::rules::if_trailing::IfWithBlocks;
use anyhow::Result;
use tree_sitter::Node;

/// Parts an `if (condition) { a } { b }` that stands on one line over
/// several, when the line is too wide with it.
pub struct ExpandLongIfTrailingClosures;

impl Rule for ExpandLongIfTrailingClosures {
    fn name(&self) -> &'static str {
        "expand_long_if_trailing_closures"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        // A pass expands the outermost if too wide for its line and skips what
        // it holds, which may be an if too wide on the line it now has: run
        // passes until none is left.
        let mut total = 0;
        loop {
            let mut edits = Vec::new();
            collect(cx, cx.tree.root_node(), &mut edits);
            let n = edits.len();
            if n == 0 {
                return Ok(total);
            }
            cx.apply_edits(edits)?;
            total += n;
        }
    }
}

/// The ifs under `node` to part, outermost first.
fn collect(cx: &Ctx, node: Node, edits: &mut Vec<TextEdit>) {
    if let Some(found) = IfWithBlocks::read(node, cx.bytes())
        && found.is_on_one_line(cx.bytes())
        && found.is_too_wide_for_one_line(cx)
    {
        edits.push(TextEdit {
            start_byte: found.start,
            end_byte: found.end,
            replacement: over_several_lines(&found, cx.bytes()),
        });
        return;
    }
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        collect(cx, child, edits);
    }
}

/// K&R style:
///
/// ```text
/// if (cond) {
///     body1
/// } {
///     body2
/// };
/// ```
fn over_several_lines(found: &IfWithBlocks, bytes: &[u8]) -> String {
    // The closing braces line up with the start of the line, which may
    // hold more than blanks before the `if` (`x = if ...`).
    let line_start = bytes[..found.start]
        .iter()
        .rposition(|&b| is_newline(b))
        .map_or(0, |at| at + 1);
    let blanks = bytes[line_start..found.start]
        .iter()
        .take_while(|&&b| is_space(b))
        .count();
    let indent = String::from_utf8_lossy(&bytes[line_start..line_start + blanks]);
    format!(
        "if ({}) {{\n{indent}    {}\n{indent}}} {{\n{indent}    {}\n{indent}}}{}",
        found.condition,
        found.then_body,
        found.else_body,
        if found.semicolon { ";" } else { "" }
    )
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
        ExpandLongIfTrailingClosures.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_the_expanded_if_adds_no_blank_line_after_it() {
        let src = "if (condition) { \"a long enough true branch to pass the width\" } { \"and the false one\" };\nx = 1;";
        assert_eq!(
            format(src),
            "if (condition) {\n    \"a long enough true branch to pass the width\"\n} {\n    \"and the false one\"\n};\nx = 1;"
        );
    }

    #[test]
    fn test_what_stands_before_the_if_on_its_line_is_not_written_again() {
        let src = "    x = if (condition) { \"a long enough true branch to pass the width\" } { \"and the false one\" };";
        assert_eq!(
            format(src),
            "    x = if (condition) {\n        \"a long enough true branch to pass the width\"\n    } {\n        \"and the false one\"\n    };"
        );
    }

    #[test]
    fn test_the_width_is_measured_with_the_space_before_the_last_brace() {
        // One line of 81 columns once written as the compactor writes it.
        let (a, b) = ("a".repeat(40), "b".repeat(25));
        let src = format!("if (c) {{ {a} }} {{ {b} }}");
        assert_eq!(src.len(), 81);
        assert_eq!(
            format(&src),
            format!("if (c) {{\n    {a}\n}} {{\n    {b}\n}}")
        );
    }

    #[test]
    fn test_the_width_is_counted_in_characters_and_not_in_bytes() {
        // 80 columns in 81 bytes: the é is two of them.
        let src = format!(
            "if (c) {{ \"{}é\" }} {{ {} }}",
            "a".repeat(36),
            "b".repeat(25)
        );
        assert_eq!((src.chars().count(), src.len()), (80, 81));
        assert_eq!(format(&src), src);
    }

    #[test]
    fn test_the_blanks_that_end_the_line_are_not_counted() {
        // They will be trimmed: counted, the if would be parted on this
        // pass and joined again on the next.
        let line = format!("if (c) {{ {} }} {{ {} }};", "a".repeat(38), "b".repeat(25));
        assert_eq!(line.len(), 80);
        let src = format!("{line}   \nx = 1;");
        assert_eq!(format(&src), src);
    }

    #[test]
    fn test_a_tab_of_indent_is_counted_as_a_level_of_four_columns() {
        // 77 columns of text one level deep: 81 with the indent.
        let (a, b) = ("a".repeat(36), "b".repeat(25));
        let src = format!("f = {{\n\tif (c) {{ {a} }} {{ {b} }}\n}}");
        let mut cx = Ctx::new(src, &grammar::language(), IndentStyle::Tabs).unwrap();
        ExpandLongIfTrailingClosures.run(&mut cx).unwrap();
        assert_eq!(
            cx.to_string(),
            format!("f = {{\n\tif (c) {{\n\t    {a}\n\t}} {{\n\t    {b}\n\t}}\n}}")
        );
    }

    #[test]
    fn test_the_width_is_measured_once_every_operator_has_its_spaces() {
        // 79 columns as written, and 81 once `===` has a space each side,
        // which no rule gave it until after this one had measured the line:
        // the if stayed on its line, and was parted on the next pass.
        let (a, b) = ("a".repeat(34), "b".repeat(24));
        let src = format!("if (c===d) {{ {a} }} {{ {b} }};\n");
        assert_eq!(src.trim_end().len(), 79);
        let once = crate::format_source(&src).unwrap();
        assert_eq!(
            once,
            format!("if (c === d) {{\n    {a}\n}} {{\n    {b}\n}};\n")
        );
        assert_eq!(crate::format_source(&once).unwrap(), once);
    }

    #[test]
    fn test_an_if_too_wide_inside_an_expanded_one_is_expanded_too() {
        let src = "if (a) { if (b) { \"a long enough true branch for the inner if\".postln } { \"and its false one\".postln } } { 3 };";
        assert_eq!(
            format(src),
            "if (a) {\n    if (b) {\n        \"a long enough true branch for the inner if\".postln\n    } {\n        \"and its false one\".postln\n    }\n} {\n    3\n};"
        );
    }
}
