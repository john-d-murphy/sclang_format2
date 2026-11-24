// src/rules/pipe_param_commas.rs

use crate::engine::ast::descendants_of_kind;
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

/// Between pipes sclang lets the comma between two arguments be left out:
/// `|a = 1 b = 2|`. This writes it in.
pub struct PipeParamAddMissingCommas;

impl Rule for PipeParamAddMissingCommas {
    fn name(&self) -> &'static str {
        "pipe_param_missing_commas"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let src = cx.bytes();
        let mut edits = Vec::new();
        for list in descendants_of_kind(cx.tree.root_node(), "pipe_parameter_list") {
            add_missing_commas(list, src, &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

fn add_missing_commas(list: Node, src: &[u8], edits: &mut Vec<TextEdit>) {
    let mut cursor = list.walk();
    let children: Vec<Node> = list.children(&mut cursor).collect();
    // An argument, and the next thing in the list that is not a comment:
    // where that is an argument too, the comma between them was left out.
    // (The rest argument, `... name`, takes none before it.)
    for (i, argument) in children.iter().enumerate() {
        let next = children[i + 1..].iter().find(|n| !n.is_extra());
        if argument.kind() != "pipe_argument" || next.is_none_or(|n| n.kind() != "pipe_argument") {
            continue;
        }
        let (start, end) = (argument.end_byte(), children[i + 1].start_byte());
        // Space alone between the two is replaced by the comma and a blank;
        // before a comment the comma is put in and the comment stays.
        let (end, replacement) = if src[start..end].iter().all(u8::is_ascii_whitespace) {
            (end, ", ")
        } else {
            (start, ",")
        };
        edits.push(TextEdit {
            start_byte: start,
            end_byte: end,
            replacement: replacement.to_string(),
        });
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
        PipeParamAddMissingCommas.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_a_missing_comma_is_added() {
        assert_eq!(format("{ |a = 1 b = 2| a }"), "{ |a = 1, b = 2| a }");
        assert_eq!(format("{ |a b\n    c| a }"), "{ |a, b, c| a }");
        assert_eq!(format("{ |a, b ... c| a }"), "{ |a, b ... c| a }");
    }

    #[test]
    fn test_a_comment_between_two_arguments_is_kept() {
        assert_eq!(
            format("{ |a /* first */ b| a }"),
            "{ |a, /* first */ b| a }"
        );
        assert_eq!(
            format("{ |a /* one, two */ b| a }"),
            "{ |a, /* one, two */ b| a }"
        );
        assert_eq!(
            format("{ |a, /* first */ b| a }"),
            "{ |a, /* first */ b| a }"
        );
    }

    #[test]
    fn test_a_name_that_ends_in_arg_is_not_an_argument_list() {
        for src in [
            "var karg, b; karg = b = 2; karg",
            "{ arg a = 1, b = 2; var karg, c; karg = c = 2; a }",
        ] {
            assert_eq!(format(src), src);
        }
    }
}
