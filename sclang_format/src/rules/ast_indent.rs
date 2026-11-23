use crate::engine::layout::{LineCursor, make_indent};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

/// Indent lines based on the tree-sitter AST nesting level.
pub struct IndentByAstLevel;

impl Rule for IndentByAstLevel {
    fn name(&self) -> &'static str {
        "indent_by_ast_level"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let tree = &cx.tree;
        let root = tree.root_node();
        let bytes_vec = cx.bytes();
        let bytes: &[u8] = bytes_vec;

        let mut edits: Vec<TextEdit> = Vec::new();
        let lines = LineCursor::new(bytes);

        for line in lines {
            if line.first_non_ws == line.end {
                continue;
            }

            let byte = line.first_non_ws;

            // Get the node at the start of the line
            let Some(node) = root.descendant_for_byte_range(byte, byte + 1) else {
                continue;
            };

            // The lines of a block comment keep the indents their writer
            // gave them, the first with the others. One that stands on one
            // line and begins it is indented like the code it stands in.
            let keeps_its_indent = node.kind() == "block_comment"
                && (node.start_byte() < byte
                    || node.end_position().row > node.start_position().row);
            if keeps_its_indent {
                continue;
            }

            let desired_indent = make_indent(cx.indent_style, cx.line_depth(byte));

            if &bytes[line.start..line.first_non_ws] != desired_indent.as_bytes() {
                edits.push(TextEdit {
                    start_byte: line.start,
                    end_byte: line.first_non_ws,
                    replacement: desired_indent.clone(),
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
    use crate::engine::{Ctx, IndentStyle};
    use crate::grammar;

    fn format(src: &str) -> String {
        let mut cx = Ctx::new(
            src.to_string(),
            &grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        let rule = IndentByAstLevel;
        rule.run(&mut cx).unwrap();
        cx.to_string()
    }

    /// `src` is indented as it should be: with its indents taken away, the
    /// rule gives them back.
    fn assert_indents(src: &str) {
        let flat: Vec<&str> = src.lines().map(str::trim_start).collect();
        assert_eq!(format(&flat.join("\n")), src);
    }

    /// What stands between a call's parentheses is one level deeper than the
    /// line the call begins on, and the closing parenthesis is level with
    /// that line, at whatever depth the call stands.
    #[test]
    fn test_a_call_over_several_lines_indents_its_arguments_and_closes_level() {
        for src in [
            "x = foo(\n    1,\n    2\n);",
            "x = foo(\n    1\n);",
            "f = {\n    z = bar(\n        1\n    );\n};",
            "f = {\n    z = bar(\n        1,\n        2\n    );\n};",
            "f = {\n    a.b(\n        1\n    ).c(\n        2\n    );\n};",
            "f = {\n    g.(\n        1\n    );\n};",
            "SynthDef(\\a, {\n    Out.ar(\n        0,\n        SinOsc.ar(\n            440\n        )\n    )\n}).add;",
            "f = {\n    if (\n        a\n    ) { b };\n};",
            "e.stream = Pbind(\n    \\degree, Pseq([0, 1, 2], inf),\n    \\dur, 0.5\n).asStream;",
            "Pdef(\n    \\test,\n    Pbind(\n        \\degree, Pseq([0, 1, 2], inf),\n        \\dur, 0.5\n    )\n);",
        ] {
            assert_indents(src);
        }
    }

    /// Parentheses that are not opened indent nothing: a block that hugs
    /// its call does the indenting for what it holds. A block or an array
    /// among arguments that stand on lines of their own is one level
    /// deeper than they are, like anything else there.
    #[test]
    fn test_a_block_among_arguments_on_their_own_lines_is_indented_under_them() {
        for src in [
            "foo(a, { |x|\n    body\n});",
            "foo(\n    a,\n    { |x|\n        body\n    }\n);",
            "foo(\n    { |x|\n        x\n    }.value(1, 2),\n    b\n);",
            "foo(\n    [\n        1,\n        2\n    ],\n    b\n);",
            "f = {\n    if (\n        { |x|\n            x\n        }.value(a)\n    ) { b };\n};",
            "SynthDef(\\test, { |freq|\n    var sig;\n    sig = SinOsc.ar(freq)\n});",
        ] {
            assert_indents(src);
        }
    }

    #[test]
    fn test_the_body_of_a_block_is_one_level_in() {
        for src in [
            "if (x > 0) {\n    body;\n};",
            "while (x > 0) {\n    body;\n};",
            "[1, 2, 3].do { |x|\n    body;\n};",
            "{\n    body;\n}.value;",
            "[1, 2, 3].do { |x|\n    [x, x * 2].do { |y|\n        y.postln;\n    };\n};",
            "MyClass {\n    *new {\n        ^super.new\n    }\n}",
        ] {
            assert_indents(src);
        }
    }

    #[test]
    fn test_a_region_of_a_file_is_not_indented() {
        assert_indents("// comment\n(\nvar a = 1;\n)");
    }

    #[test]
    fn test_the_tests_of_a_switch_are_one_level_in() {
        assert_indents(
            "switch (x,\n    0, { \"zero\".postln },\n    1, { \"one\".postln },\n    { \"other\".postln }\n);",
        );
    }

    #[test]
    fn test_single_line_function_call_no_indent() {
        let src = "SinOsc.ar(440, 0, 0.1);";
        assert_eq!(format(src), src);
    }

    #[test]
    fn test_a_block_comment_on_one_line_is_indented_like_code() {
        assert_indents("f = {\n    /* why */ a;\n    /* and */\n    b\n};");
    }

    #[test]
    fn test_block_comment_content_preserved() {
        // Content inside block comments should NOT be re-indented
        let src = r#"/*
    if(x>0){
        "nope".postln;
    }
*/"#;
        assert_eq!(format(src), src);
    }
}
