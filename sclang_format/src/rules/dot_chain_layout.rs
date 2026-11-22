use crate::engine::ast::descendants_of_kind;
use crate::engine::text::{is_newline, is_space};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

/// A dot that ends a line moves to the start of the next, before the name
/// it sends: `foo.` and `bar` on two lines are `foo` and `.bar`.
pub struct DotChainLayout;

impl Rule for DotChainLayout {
    fn name(&self) -> &'static str {
        "dot_chain_layout"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let root = cx.tree.root_node();
        let mut edits = Vec::new();

        let calls = descendants_of_kind(root, "method_call")
            .chain(descendants_of_kind(root, "instance_variable_setter_call"));
        for call in calls {
            // The dot, and the name straight after it.
            let (Some(dot), Some(name)) = (call.child(0), call.child(1)) else {
                continue;
            };
            let at = dot.start_byte();
            // A dot straight after a digit is left where it is (`1.` and
            // `neg` on two lines), as it always was.
            if dot.kind() != "." || (at > 0 && bytes[at - 1].is_ascii_digit()) {
                continue;
            }
            // A dot that begins its line is where it should be.
            let before = bytes[..at].iter().rposition(|&b| !is_space(b));
            if before.is_none_or(|i| is_newline(bytes[i])) {
                continue;
            }
            // Between the dot and the name: blanks, one line break, blanks.
            let gap = &bytes[dot.end_byte()..name.start_byte()];
            let blanks = gap.iter().take_while(|&&b| is_space(b)).count();
            let line_break = match &gap[blanks..] {
                [b'\r', b'\n', ..] => 2,
                [b'\r' | b'\n', ..] => 1,
                _ => continue,
            };
            if !gap[blanks + line_break..].iter().all(|&b| is_space(b)) {
                continue;
            }

            edits.push(TextEdit {
                start_byte: at,
                end_byte: dot.end_byte() + blanks,
                replacement: String::new(),
            });
            edits.push(TextEdit {
                start_byte: name.start_byte(),
                end_byte: name.start_byte(),
                replacement: ".".to_string(),
            });
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
        DotChainLayout.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_a_dot_that_ends_a_line_begins_the_next() {
        assert_eq!(format("a.\n    b.  \n    c(1);"), "a\n    .b\n    .c(1);");
        assert_eq!(format("a.\r\n    b;"), "a\r\n    .b;");
    }

    #[test]
    fn test_other_dots_stay() {
        for src in [
            "a\n    .b\n    .c;",
            "a.b.c;",
            "x = 1.5;\ny = (1..\n    3);",
            "a. // why\n    b;",
            "a.\n\n    b;",
            "x = \"a.\n    b\";",
            "x = $\"; a.b; y = $\";",
        ] {
            assert_eq!(format(src), src);
        }
    }

    #[test]
    fn test_a_quote_character_before_it_does_not_hide_a_dot() {
        assert_eq!(format("x = $\";\na.\n    b;"), "x = $\";\na\n    .b;");
    }
}
