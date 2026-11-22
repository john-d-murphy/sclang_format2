// src/rules/pipe_body.rs

use crate::engine::ast::descendants_of_kind;
use crate::engine::text::{is_newline, is_space};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

/// One space between a block's closing pipe and its body on the same line,
/// and none after a pipe that ends its line: `{ |a|a }` is `{ |a| a }`.
pub struct PipeBodySpacing;

impl Rule for PipeBodySpacing {
    fn name(&self) -> &'static str {
        "pipe_body_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let mut edits = Vec::new();

        for list in descendants_of_kind(cx.tree.root_node(), "pipe_parameter_list") {
            // The brace and the two pipes, when all three are on one line
            // with nothing but blanks between the brace and the first pipe.
            let Some(brace) = list
                .parent()
                .and_then(|parameters| parameters.prev_sibling())
                .filter(|brace| brace.kind() == "{")
            else {
                continue;
            };
            let (Some(open), Some(close)) = (list.child(0), list.child(list.child_count() - 1))
            else {
                continue;
            };
            let row = brace.start_position().row;
            if open.start_position().row != row
                || close.start_position().row != row
                || !bytes[brace.end_byte()..open.start_byte()]
                    .iter()
                    .all(|&b| is_space(b))
            {
                continue;
            }

            let start = close.end_byte();
            let blanks = bytes[start..].iter().take_while(|&&b| is_space(b)).count();
            let ends_line = bytes.get(start + blanks).is_none_or(|&b| is_newline(b));
            let wanted = if ends_line { "" } else { " " };
            if &bytes[start..start + blanks] != wanted.as_bytes() {
                edits.push(TextEdit {
                    start_byte: start,
                    end_byte: start + blanks,
                    replacement: wanted.to_string(),
                });
            }
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
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
        PipeBodySpacing.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_one_space_after_the_closing_pipe_and_none_at_the_end_of_a_line() {
        assert_eq!(format("f = { |a|a };"), "f = { |a| a };");
        assert_eq!(format("f = { |a|   a };"), "f = { |a| a };");
        assert_eq!(format("f = { |a|  \n    a\n};"), "f = { |a|\n    a\n};");
        assert_eq!(format("f = {|a|}"), "f = {|a| }");
    }

    #[test]
    fn test_a_pipe_in_a_character_a_string_or_an_expression_is_not_the_lists() {
        for src in [
            "x = $\"; f = { |a| a }; y = $\";",
            "x = $'; f = { |a| a }; y = $';",
            "f = { |a = \"|\"| a };",
            "f = { |a = $|| a };",
            "f = { a |b| c };",
        ] {
            assert_eq!(format(src), src);
        }
        assert_eq!(
            format("x = $\"; f = { |a|a }; y = $\";"),
            "x = $\"; f = { |a| a }; y = $\";"
        );
    }
}
