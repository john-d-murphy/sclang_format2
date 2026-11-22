use crate::engine::ast::{descendants_of_kind, is_literal_default};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

/// Parenthesizes a default between pipes that sclang would not take.
///
/// Between pipes sclang takes a default that is a literal, or an expression
/// in parentheses, and nothing else. A default that is neither is put in
/// parentheses, and the two that sclang takes are left as they are.
pub struct PipeParamDefaultParens;

impl Rule for PipeParamDefaultParens {
    fn name(&self) -> &'static str {
        "pipe_param_default_parens"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes();
        let mut edits = Vec::new();

        for arg in descendants_of_kind(cx.tree.root_node(), "pipe_argument") {
            let mut cursor = arg.walk();
            let children: Vec<Node> = arg.children(&mut cursor).collect();
            // The default follows the equals sign. The older `name(value)` is
            // parenthesized already, and `name value` takes only a literal.
            let Some(value) = children
                .iter()
                .skip_while(|child| child.kind() != "=")
                .find(|child| child.is_named() && !child.is_extra())
            else {
                continue;
            };
            if is_literal_default(*value, src) || value.kind() == "code_block" {
                continue;
            }
            let text = String::from_utf8_lossy(&src[value.start_byte()..value.end_byte()]);
            edits.push(TextEdit {
                start_byte: value.start_byte(),
                end_byte: value.end_byte(),
                replacement: format!("({text})"),
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
        PipeParamDefaultParens.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_the_rest_argument_is_not_part_of_the_default_before_it() {
        let src = "f = { |freq = 440, dur = 1 ... more| dur };";
        assert_eq!(format(src), src);
        assert_eq!(
            format("f = { |dur = 1.neg ... more| dur };"),
            "f = { |dur = (1.neg) ... more| dur };"
        );
    }

    /// sclang compiles a parenthesized default as code that fills the
    /// argument in when it is nil, and a literal as the value the function is
    /// made with: `{ |a = (#[1, 2])| a }.value(nil)` is [1, 2], and nil
    /// without the parentheses.
    #[test]
    fn test_a_literal_default_is_never_parenthesized() {
        for src in [
            "{ |a = #[1, 2], b = #Array[1]| a }",
            "{ |a = inf, b = -inf, c = pi, d = 2pi, e = -2pi, f = - 1| a }",
            "{ |a = $x, b = 'q z', c = \\q, d = $ | a }",
            "{ |a = \"...\", b = \"a|b\" \"c\"| a }",
            "{ |a = 2s, b = 1e-3, c = 16rFF, d = 0x1F, e = 1.5| a }",
            "{ |a = nil, b = true| a }",
            "{ |a(3), b 4, c = (1 + 2), d = (1; 2)| a }",
        ] {
            assert_eq!(format(src), src);
        }
    }

    #[test]
    fn test_any_other_default_is_parenthesized() {
        assert_eq!(format("{ |a = b| a }"), "{ |a = (b)| a }");
        assert_eq!(format("{ |a = [1, 2]| a }"), "{ |a = ([1, 2])| a }");
        assert_eq!(
            format("{ |a = (1 + 2).neg| a }"),
            "{ |a = ((1 + 2).neg)| a }"
        );
        assert_eq!(format("{ |a = (1..3)| a }"), "{ |a = ((1..3))| a }");
        assert_eq!(
            format("{\n    |a = Env.perc|\n    a\n}"),
            "{\n    |a = (Env.perc)|\n    a\n}"
        );
    }
}
