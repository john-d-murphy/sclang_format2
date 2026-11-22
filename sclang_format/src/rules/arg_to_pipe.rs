// src/rules/arg_to_pipe.rs

use crate::engine::ast::{descendants_of_kind, is_literal_default};
use crate::engine::text::is_space;
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

/// Writes a function's `arg a, b;` as `|a, b|` after its brace.
pub struct ArgToPipeParams;

impl Rule for ArgToPipeParams {
    fn name(&self) -> &'static str {
        "arg_to_pipe_params"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let mut edits = Vec::new();
        for block in descendants_of_kind(cx.tree.root_node(), "function_block") {
            convert(block, cx.bytes(), &mut edits);
        }

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

fn text(bytes: &[u8], node: Node) -> String {
    String::from_utf8_lossy(&bytes[node.byte_range()]).to_string()
}

/// Whether `node` is an expression in parentheses, `(a + b)` or `(a; b)`:
/// the one default that is not a literal and stands between pipes as it
/// is. An event `(a: 1)`, the empty `()` and a series `(1..3)` begin with
/// a parenthesis too, and are not.
fn is_parenthesized_expression(node: Node) -> bool {
    let mut cursor = node.walk();
    node.kind() == "code_block"
        && node.named_child_count() > 0
        && node.child_by_field_name("pairs").is_none()
        && !node.children(&mut cursor).any(|child| child.kind() == ",")
}

/// One argument as it is written between pipes. What sclang compiles was
/// asked of sclang: `arg a = X;` is `|a = X|` when X is a literal and
/// `|a = (X)|` when it is anything else, and the older `arg a(X);` is
/// `|a = (X)|` whatever X is.
fn pipe_argument(argument: Node, bytes: &[u8]) -> Option<String> {
    let name = text(bytes, argument.child_by_field_name("name")?);

    let mut cursor = argument.walk();
    let Some(default) = argument
        .children(&mut cursor)
        .find(|child| child.kind() == "argument_default")
    else {
        return Some(name);
    };
    let value = default.child_by_field_name("value")?;
    let value_text = text(bytes, value);

    let older_form = default.child(0).is_some_and(|n| n.kind() == "(");
    if !older_form && (is_literal_default(value, bytes) || is_parenthesized_expression(value)) {
        Some(format!("{name} = {value_text}"))
    } else {
        Some(format!("{name} = ({value_text})"))
    }
}

/// The edits that turn the `arg` list of `block`, if it has one, into pipes.
fn convert(block: Node, bytes: &[u8], edits: &mut Vec<TextEdit>) {
    let Some(param_list) = block.child_by_field_name("params") else {
        return;
    };
    let mut cursor = param_list.walk();
    let children: Vec<Node> = param_list.children(&mut cursor).collect();
    // Between pipes already; or with a comment in the list, which is deleted
    // below and would take the comment with it.
    if children.iter().any(|child| {
        matches!(
            child.kind(),
            "pipe_parameter_list" | "line_comment" | "block_comment"
        )
    }) {
        return;
    }

    let mut params = Vec::new();
    // The rest argument (`... name`) follows the others after a space, not a comma.
    let mut rest = None;
    for argument in children.iter().filter(|child| child.kind() == "argument") {
        let Some(written) = pipe_argument(*argument, bytes) else {
            continue;
        };
        if argument.child(0).is_some_and(|n| n.kind() == "...") {
            rest = Some(format!("... {written}"));
        } else {
            params.push(written);
        }
    }
    let mut params = params.join(", ");
    if let Some(rest) = rest {
        if !params.is_empty() {
            params.push(' ');
        }
        params.push_str(&rest);
    }
    // Safety check for strings (still want to avoid these)
    if params.is_empty() || params.contains('"') || params.contains('\'') {
        return;
    }

    let mut cursor = block.walk();
    let Some(brace) = block
        .children(&mut cursor)
        .find(|child| child.kind() == "{")
    else {
        return;
    };

    // The list goes, and its whole line with it when it stood alone on one.
    // On the brace's own line the line break after it stays, so that what
    // follows (a `var` line) keeps a line of its own.
    let line_start = bytes[..param_list.start_byte()]
        .iter()
        .rposition(|&b| b == b'\n')
        .map_or(0, |at| at + 1);
    let alone = bytes[line_start..param_list.start_byte()]
        .iter()
        .all(|&b| is_space(b));
    let mut end = param_list.end_byte();
    if alone && bytes[end..].starts_with(b"\r\n") {
        end += 2;
    } else if alone && bytes[end..].starts_with(b"\n") {
        end += 1;
    }

    edits.push(TextEdit {
        start_byte: brace.end_byte(),
        end_byte: brace.end_byte(),
        replacement: format!(" |{params}|"),
    });
    edits.push(TextEdit {
        start_byte: if alone {
            line_start
        } else {
            param_list.start_byte()
        },
        end_byte: end,
        replacement: String::new(),
    });
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
        ArgToPipeParams.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_the_rest_argument_keeps_its_dots() {
        assert!(format("f = { arg a, b = 1 ... rest; a };").contains("{ |a, b = 1 ... rest|"));
        assert!(format("g = { arg ...all; all };").contains("{ |... all|"));
    }

    #[test]
    fn test_an_arg_list_with_a_comment_in_it_is_left_alone() {
        let src = "f = {\n    arg freq = 440, // the pitch\n        amp = 0.1;\n    freq * amp\n};";
        assert_eq!(format(src), src);
        let src = "f = { arg freq /* Hz */, amp; freq * amp };";
        assert_eq!(format(src), src);
    }

    /// What sclang compiles each to was asked of sclang: `arg a = X;` is
    /// `|a = X|` for a literal and `|a = (X)|` for anything else, and
    /// `arg a(X);` is `|a = (X)|` whatever X is.
    #[test]
    fn test_a_default_is_parenthesized_unless_it_is_a_literal() {
        for (arg, pipe) in [
            ("a = 1", "a = 1"),
            ("a = -1", "a = -1"),
            ("a = #[1, 2]", "a = #[1, 2]"),
            ("a = inf", "a = inf"),
            ("a = -inf", "a = -inf"),
            ("a = 2pi", "a = 2pi"),
            ("a = $x", "a = $x"),
            ("a = \\q", "a = \\q"),
            ("a = nil", "a = nil"),
            ("a = true", "a = true"),
            ("a = [1, 2]", "a = ([1, 2])"),
            ("a = b", "a = (b)"),
            ("a = thisProcess", "a = (thisProcess)"),
            ("a = Env.perc", "a = (Env.perc)"),
            ("a = 1 + 2", "a = (1 + 2)"),
            ("a = (1 + 2)", "a = (1 + 2)"),
            ("a = (1; 2)", "a = (1; 2)"),
            ("a = (1 + 2).neg", "a = ((1 + 2).neg)"),
            ("a = (b: 1)", "a = ((b: 1))"),
            ("a = ()", "a = (())"),
            ("a = (1..3)", "a = ((1..3))"),
            ("a(3)", "a = (3)"),
            ("a(3 + 1)", "a = (3 + 1)"),
        ] {
            let out = format(&format!("{{ arg {arg}; a }}"));
            assert!(out.contains(&format!("{{ |{pipe}|")), "{arg}: {out}");
        }
    }
}
