use crate::engine::ast_utils::visual_block_depth_at;
use crate::engine::layout::{LineCursor, make_indent};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

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

            // Skip lines inside block comments - don't re-indent their contents
            if is_inside_block_comment(&node) {
                continue;
            }

            let depth = line_depth(root, bytes, byte);

            let desired_indent = make_indent(cx.indent_style, depth);

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

/// Check if a node is inside a block comment
fn is_inside_block_comment(node: &Node) -> bool {
    let mut current = Some(*node);
    while let Some(n) = current {
        if n.kind() == "block_comment" {
            return true;
        }
        current = n.parent();
    }
    false
}

/// The depth of the line whose first character that is not a blank is at
/// `first`: what the tree says, less one for a line that begins with a
/// closing bracket (`};`, `).play;`, `}.value;`), which stands level with
/// the line its bracket was opened on.
pub(super) fn line_depth(root: Node, bytes: &[u8], first: usize) -> usize {
    let depth = visual_block_depth_at(root, first, bytes);
    if matches!(bytes[first], b'}' | b']' | b')') {
        depth.saturating_sub(1)
    } else {
        depth
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::engine::ast_utils::block_depth_at;
    use crate::engine::{Ctx, IndentStyle};
    use crate::grammar;
    use tree_sitter::Parser;

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
            "f = {\n    z = bar(1,\n        2\n    );\n};",
            "SynthDef(\\a, {\n    Out.ar(0,\n        SinOsc.ar(\n            440\n        )\n    )\n}).add;",
            "f = {\n    if(\n        a\n    ) { b };\n};",
        ] {
            let flat: Vec<&str> = src.lines().map(str::trim_start).collect();
            assert_eq!(format(&flat.join("\n")), src);
        }
    }

    /// A block or an array that begins on the line of the call's opening
    /// parenthesis does the indenting for what it holds. One that begins
    /// among arguments that stand on lines of their own is one level deeper
    /// than they are, like anything else there.
    #[test]
    fn test_a_block_among_arguments_on_their_own_lines_is_indented_under_them() {
        for src in [
            "foo(a, { |x|\n    body\n}, b);",
            "foo(a, [\n    1,\n    2\n]);",
            "foo(\n    a, { |x|\n        body\n    }\n);",
            "foo(\n    { |x|\n        x\n    }.value(1, 2),\n    b\n);",
            "foo(\n    [\n        1,\n        2\n    ], b\n);",
            "f = {\n    if (\n        { |x|\n            x\n        }.value(a)\n    ) { b };\n};",
        ] {
            let flat: Vec<&str> = src.lines().map(str::trim_start).collect();
            assert_eq!(format(&flat.join("\n")), src);
        }
    }

    #[test]
    fn test_simple_if_block() {
        let src = r"if (x > 0) {
body;
};";
        let result = format(src);
        eprintln!("Result:\n{result}");
        assert!(
            result.contains("\n    body;"),
            "body should have 4 spaces indent"
        );
    }

    #[test]
    fn test_while_block() {
        let src = r"while (x > 0) {
body;
};";
        let result = format(src);
        eprintln!("Result:\n{result}");
        assert!(
            result.contains("\n    body;"),
            "while body should have 4 spaces indent"
        );
    }

    #[test]
    fn test_trailing_closure_do() {
        let src = r"[1, 2, 3].do { |x|
body;
};";
        let result = format(src);
        eprintln!("Result:\n{result}");
        assert!(
            result.contains("\n    body;"),
            ".do body should have 4 spaces indent"
        );
    }

    #[test]
    fn test_receiver_block_value() {
        let src = r"{
body;
}.value;";
        let result = format(src);
        eprintln!("Result:\n{result}");
        assert!(
            result.contains("\n    body;"),
            "receiver block body should have 4 spaces indent"
        );
    }

    #[test]
    fn test_nested_trailing_closures() {
        let src = r"[1, 2, 3].do { |x|
[x, x * 2].do { |y|
y.postln;
};
};";

        // Debug: check what block_depth_at and visual_block_depth_at return
        let mut parser = Parser::new();
        parser.set_language(&crate::grammar::language()).unwrap();
        let bytes = src.as_bytes();
        let tree = parser.parse(bytes, None).unwrap();
        let root = tree.root_node();

        // Find position of inner "[x, x * 2]"
        let inner_bracket_pos = src.find("[x,").unwrap();
        let inner_block_depth = block_depth_at(root, inner_bracket_pos, bytes);
        let inner_visual_depth = visual_block_depth_at(root, inner_bracket_pos, bytes);
        eprintln!(
            "Inner bracket '[x,' at byte {inner_bracket_pos}: block_depth = {inner_block_depth}, visual_depth = {inner_visual_depth}"
        );

        // Debug: dump node ancestry
        if let Some(mut node) =
            root.descendant_for_byte_range(inner_bracket_pos, inner_bracket_pos + 1)
        {
            eprintln!("Node ancestry for '[x,':");
            loop {
                eprintln!(
                    "  {} [{}..{}]",
                    node.kind(),
                    node.start_byte(),
                    node.end_byte()
                );
                if let Some(parent) = node.parent() {
                    node = parent;
                } else {
                    break;
                }
            }
        }

        // Find position of "y.postln"
        let y_pos = src.find("y.postln").unwrap();
        let y_block_depth = block_depth_at(root, y_pos, bytes);
        let y_visual_depth = visual_block_depth_at(root, y_pos, bytes);
        eprintln!(
            "'y.postln' at byte {y_pos}: block_depth = {y_block_depth}, visual_depth = {y_visual_depth}"
        );

        let result = format(src);
        eprintln!("Result:\n{result}");
        assert!(
            result.contains("\n    [x, x * 2]"),
            "inner .do should have 4 spaces"
        );
        assert!(
            result.contains("\n        y.postln"),
            "innermost body should have 8 spaces"
        );
    }

    #[test]
    fn test_class_methods() {
        let src = r"MyClass {
*new {
^super.new
}
}";

        // Debug: check depths for class members
        let mut parser = Parser::new();
        parser.set_language(&crate::grammar::language()).unwrap();
        let bytes = src.as_bytes();
        let tree = parser.parse(bytes, None).unwrap();
        let root = tree.root_node();

        // Check if there's an ERROR node (parse failure)
        eprintln!("Tree has error: {}", root.has_error());

        // Check depth for "MyClass" at byte 0
        let myclass_block_depth = block_depth_at(root, 0, bytes);
        let myclass_visual_depth = visual_block_depth_at(root, 0, bytes);
        eprintln!(
            "'MyClass' at byte 0: block_depth = {myclass_block_depth}, visual_depth = {myclass_visual_depth}"
        );

        // Find position of "*new"
        let star_pos = src.find("*new").unwrap();
        let star_block_depth = block_depth_at(root, star_pos, bytes);
        let star_visual_depth = visual_block_depth_at(root, star_pos, bytes);
        eprintln!(
            "'*new' at byte {star_pos}: block_depth = {star_block_depth}, visual_depth = {star_visual_depth}"
        );

        // Debug: dump node ancestry
        if let Some(mut node) = root.descendant_for_byte_range(star_pos, star_pos + 1) {
            eprintln!("Node ancestry for '*new':");
            loop {
                eprintln!(
                    "  {} [{}..{}]",
                    node.kind(),
                    node.start_byte(),
                    node.end_byte()
                );
                if let Some(parent) = node.parent() {
                    node = parent;
                } else {
                    break;
                }
            }
        }

        let result = format(src);
        eprintln!("Result:\n{result}");
        assert!(result.contains("\n    *new"), "*new should have 4 spaces");
        assert!(
            result.contains("\n        ^super"),
            "method body should have 8 spaces"
        );
    }

    #[test]
    fn test_synthdef_body() {
        let src = r"SynthDef(\test, { |freq|
var sig;
sig = SinOsc.ar(freq);
});";
        let result = format(src);
        eprintln!("Result:\n{result}");
        assert!(
            result.contains("\n    var sig"),
            "SynthDef body should have 4 spaces"
        );
    }

    #[test]
    fn debug_ast_indent_rule_execution() {
        let src = r"// comment
(
var a = 1;
)
";
        let result = format(src);
        eprintln!("RESULT:\n'{result}'");
        assert!(
            result.contains("\nvar a = 1;"),
            "var a should have 0 indent"
        );
    }

    #[test]
    fn test_multiline_function_call_pbind() {
        // This is the Pbind pattern that was failing
        let src = r"e.stream = Pbind(
\degree, Pseq([0, 1, 2], inf),
\dur, 0.5
).asStream;";
        let result = format(src);
        eprintln!("Result:\n{result}");
        assert!(
            result.contains("\n    \\degree"),
            "Pbind arguments should be indented 4 spaces"
        );
        assert!(
            result.contains("\n    \\dur"),
            "All Pbind arguments should be indented"
        );
    }

    #[test]
    fn test_multiline_function_call_synthdef() {
        // When function block is on its own line (as an argument), it gets indented by param list
        let src = r"SynthDef(\test,
{ |freq|
var sig;
sig = SinOsc.ar(freq);
});";
        let result = format(src);
        eprintln!("Result:\n{result}");
        // The { is on a new line, so it's indented by the param list
        // var sig is inside function block, so it gets another level
        assert!(
            result.contains("\n    { |freq|"),
            "Function block should be indented as param"
        );
        assert!(
            result.contains("\n        var sig"),
            "SynthDef body should be double-indented (param list + function block)"
        );
    }

    #[test]
    fn test_single_line_function_call_no_indent() {
        // Single-line calls should NOT add depth
        let src = r"SinOsc.ar(440, 0, 0.1);";
        let result = format(src);
        eprintln!("Result:\n{result}");
        // Should remain on one line, no indent changes
        assert_eq!(result.trim(), src.trim());
    }

    #[test]
    fn test_block_comment_content_preserved() {
        // Content inside block comments should NOT be re-indented
        let src = r#"/*
    if(x>0){
        "nope".postln;
    }
*/"#;
        let result = format(src);
        eprintln!("Result:\n{result}");
        // The content inside the comment should be unchanged
        assert!(
            result.contains("    if(x>0){"),
            "Block comment content should preserve original indentation"
        );
        assert!(
            result.contains("        \"nope\".postln;"),
            "Nested content in block comment should be unchanged"
        );
    }

    #[test]
    fn test_nested_multiline_calls() {
        let src = r"Pdef(\test,
Pbind(
\degree, Pseq([0, 1, 2], inf),
\dur, 0.5
)
);";
        let result = format(src);
        eprintln!("Result:\n{result}");
        // Pbind should be indented once (inside Pdef's param list)
        assert!(
            result.contains("\n    Pbind"),
            "Pbind should be indented inside Pdef"
        );
        // \degree should be indented twice (inside Pdef AND Pbind param lists)
        assert!(
            result.contains("\n        \\degree"),
            "Pbind arguments should be double-indented"
        );
    }

    #[test]
    fn test_switch_cases_not_double_indented() {
        let src = r#"switch (x,
0, { "zero".postln },
1, { "one".postln },
{ "other".postln }
);"#;
        let result = format(src);
        eprintln!("Result:\n{result}");
        // Switch cases should only be indented once
        assert!(
            result.contains("\n    0, {"),
            "Switch cases should be indented 4 spaces"
        );
    }

    #[test]
    fn test_array_in_function_call() {
        let src = r"Synth(\test, [
freq, 440,
amp, 0.1
]);";
        let result = format(src);
        eprintln!("Result:\n{result}");
        // Array contents should be indented once (inside the [...])
        // The param list shouldn't add another level because we're inside a collection
        assert!(
            result.contains("\n    freq, 440"),
            "Array contents in function call should be indented 4 spaces"
        );
    }
}
