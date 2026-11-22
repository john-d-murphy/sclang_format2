// src/rules/var_arg.rs
use crate::engine::ast::tokens_of_kinds;
use crate::engine::text::{is_newline, is_space};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

/// Ensure exactly one ASCII space after a keyword (`var` or `arg`),
/// unless the next non-space is a newline/EOF.
fn fix_after_keyword(bytes: &[u8], l: usize, edits: &mut Vec<TextEdit>) {
    let len = bytes.len();
    if l >= len {
        return;
    }

    let mut r = l;
    while r < len && is_space(bytes[r]) && !is_newline(bytes[r]) {
        r += 1;
    }

    if r == l {
        // no spaces currently after keyword
        if r < len && !is_newline(bytes[r]) {
            edits.push(TextEdit {
                start_byte: l,
                end_byte: l,
                replacement: " ".to_string(),
            });
        }
    } else {
        // some spaces; compress to a single one
        if r - l != 1 {
            edits.push(TextEdit {
                start_byte: l,
                end_byte: r,
                replacement: " ".to_string(),
            });
        }
    }
}

/// One space after `var` and after `arg`.
pub struct VarAndArgSpacing;

impl Rule for VarAndArgSpacing {
    fn name(&self) -> &'static str {
        "var_and_arg_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let mut edits = Vec::new();
        for keyword in tokens_of_kinds(cx.tree.root_node(), &["var", "arg"]) {
            fix_after_keyword(bytes, keyword.end_byte(), &mut edits);
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
        VarAndArgSpacing.run(&mut cx).unwrap();
        cx.to_string()
    }

    /// A rule that counts quotes or brackets is lost after a character that
    /// is one. The tokens of the tree are what they are wherever they stand.
    #[test]
    fn test_a_quote_or_bracket_character_before_it_hides_nothing() {
        assert_eq!(
            format("x = $\"; f = { var  c, d; c };"),
            "x = $\"; f = { var c, d; c };"
        );
        assert_eq!(
            format("x = $'; f = { arg  c; c };"),
            "x = $'; f = { arg c; c };"
        );
    }
}
