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
        let bytes: &[u8] = &bytes_vec;


        let mut edits: Vec<TextEdit> = Vec::new();
        let mut lines = LineCursor::new(bytes);


        while let Some(line) = lines.next() {
            if line.first_non_ws == line.end {
                continue;
            }


            let content = &bytes[line.first_non_ws..line.end];
            let is_line_comment = content.starts_with(b"//");
            let byte = line.first_non_ws;


            // Get the node at the start of the line
            let node = match root.descendant_for_byte_range(byte, byte + 1) {
                Some(n) => n,
                None => continue,
            };


            // Skip lines inside block comments - don't re-indent their contents
            if is_inside_block_comment(&node) {
                continue;
            }


            // 1. Calculate structural depth from AST
            let mut depth = visual_block_depth_at(root, byte, bytes);


            // 2. Adjust for lines starting with closing delimiters
            // This handles both pure delimiter lines like `};` AND
            // lines like `).play;` or `}.value;`
            let starts_closing = starts_with_closing_delim(content);
            if !is_line_comment && starts_closing && depth > 0 {
                depth -= 1;
            }


            // 3. Adjust for block headers (like 'if (...) {') which visually sit outside
            let is_block_header = is_function_block_header(&node);
            if is_block_header && depth > 0 {
                depth -= 1;
            }


            // 4. Adjust for switch cases
            let is_switch_case = is_case_like_line_after_switch(&node, bytes);
            if is_switch_case && depth > 0 {
                depth -= 1;
            }


            // 5. Trailing Closure Handling
            // NOTE: This is now handled in block_depth_at by not double-counting
            // method_call when we're inside its trailing function_block.


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


fn is_case_like_line_after_switch(node: &Node, _src: &[u8]) -> bool {
    let kind = node.kind();
    if kind != "function_block" && kind != "literal" {
        return false;
    }


    if let Some(parent) = node.parent() {
        if parent.kind() == "switch" {
            return true;
        }
    }


    false
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


#[allow(dead_code)] // Kept for potential future use
/// Count how many levels of trailing closures we're nested inside.
/// A trailing closure is a function_block that's NOT the receiver of a method_call/function_call,
/// and is NOT part of a control-flow construct (if/while/for/switch).
fn count_trailing_closure_depth(node: &Node, src: &[u8]) -> usize {
    let mut count = 0;
    let mut current = Some(*node);


    while let Some(n) = current {
        if n.kind() == "function_block" {
            if let Some(parent) = n.parent() {
                let pk = parent.kind();


                // Skip if parent is a control structure node
                if pk == "if" || pk == "while" || pk == "for" || pk == "switch" {
                    current = n.parent();
                    continue;
                }


                // Check if this function_block is a trailing block of method_call/function_call
                if pk == "method_call" || pk == "function_call" {
                    // Check if this is a control-flow function call (while, if, etc.)
                    if pk == "function_call" {
                        if let Some(name_node) = parent.child_by_field_name("name") {
                            let name_start = name_node.start_byte();
                            let name_end = name_node.end_byte();
                            if name_start < src.len() && name_end <= src.len() {
                                let name = &src[name_start..name_end];
                                // Don't treat control-flow keywords as trailing closures
                                if name == b"if" || name == b"while" || name == b"for" || name == b"switch" || name == b"case" {
                                    current = n.parent();
                                    continue;
                                }
                            }
                        }
                    }


                    // If we're the first named child, we're the receiver (e.g., { }.value)
                    // If we're NOT the first child, we're a trailing block argument
                    if let Some(first_child) = parent.named_child(0) {
                        if first_child.id() != n.id() {
                            // We're a trailing block, not a receiver
                            count += 1;
                        }
                    }
                }
            }
        }
        current = n.parent();
    }


    count
}


#[allow(dead_code)] // Kept for potential future use
fn is_trailing_closure_header_line(node: &Node, content: &[u8], _src: &[u8]) -> bool {
    if node.kind() != "function_block" {
        return false;
    }


    if let Some(parent) = node.parent() {
        let pk = parent.kind();
        if pk != "method_call" && pk != "function_call" {
            return false;
        }
    }


    content.contains(&b'{') && !is_pure_delim_line(content)
}


fn is_pure_delim_line(line: &[u8]) -> bool {
    let mut saw_non_ws = false;


    for &b in line {
        if b.is_ascii_whitespace() {
            continue;
        }


        saw_non_ws = true;


        match b {
            b'{' | b'}' | b'(' | b')' | b'[' | b']' | b',' | b';' => {}
            _ => return false,
        }
    }


    saw_non_ws
}


/// Check if a line starts with a closing delimiter (}, ], or ))
/// Used for outdenting lines like `}.value;` or `).play;`
fn starts_with_closing_delim(content: &[u8]) -> bool {
    // content is already trimmed to start at first non-whitespace
    matches!(content.first(), Some(b'}') | Some(b']') | Some(b')'))
}


fn is_function_block_header(node: &Node) -> bool {
    match node.kind() {
        "if" | "while" | "for" | "switch" => {
            let count = node.named_child_count();
            for i in 0..count {
                if let Some(child) = node.named_child(i) {
                    if child.kind() == "function_block" {
                        return true;
                    }
                }
            }
            false
        }
        _ => false,
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
            grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        let rule = IndentByAstLevel;
        rule.run(&mut cx).unwrap();
        cx.to_string()
    }


    #[test]
    fn test_simple_if_block() {
        let src = r#"if (x > 0) {
body;
};"#;
        let result = format(src);
        eprintln!("Result:\n{}", result);
        assert!(result.contains("\n    body;"), "body should have 4 spaces indent");
    }


    #[test]
    fn test_while_block() {
        let src = r#"while (x > 0) {
body;
};"#;
        let result = format(src);
        eprintln!("Result:\n{}", result);
        assert!(result.contains("\n    body;"), "while body should have 4 spaces indent");
    }


    #[test]
    fn test_trailing_closure_do() {
        let src = r#"[1, 2, 3].do { |x|
body;
};"#;
        let result = format(src);
        eprintln!("Result:\n{}", result);
        assert!(result.contains("\n    body;"), ".do body should have 4 spaces indent");
    }


    #[test]
    fn test_receiver_block_value() {
        let src = r#"{
body;
}.value;"#;
        let result = format(src);
        eprintln!("Result:\n{}", result);
        assert!(result.contains("\n    body;"), "receiver block body should have 4 spaces indent");
    }


    #[test]
    fn test_nested_trailing_closures() {
        let src = r#"[1, 2, 3].do { |x|
[x, x * 2].do { |y|
y.postln;
};
};"#;


        // Debug: check what block_depth_at and visual_block_depth_at return
        use crate::engine::ast_utils::{block_depth_at, visual_block_depth_at};
        use tree_sitter::Parser;
        let mut parser = Parser::new();
        parser.set_language(&crate::grammar::language()).unwrap();
        let bytes = src.as_bytes();
        let tree = parser.parse(bytes, None).unwrap();
        let root = tree.root_node();


        // Find position of inner "[x, x * 2]"
        let inner_bracket_pos = src.find("[x,").unwrap();
        let inner_block_depth = block_depth_at(root, inner_bracket_pos, bytes);
        let inner_visual_depth = visual_block_depth_at(root, inner_bracket_pos, bytes);
        eprintln!("Inner bracket '[x,' at byte {}: block_depth = {}, visual_depth = {}",
                  inner_bracket_pos, inner_block_depth, inner_visual_depth);


        // Debug: dump node ancestry
        if let Some(mut node) = root.descendant_for_byte_range(inner_bracket_pos, inner_bracket_pos + 1) {
            eprintln!("Node ancestry for '[x,':");
            loop {
                eprintln!("  {} [{}..{}]", node.kind(), node.start_byte(), node.end_byte());
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
        eprintln!("'y.postln' at byte {}: block_depth = {}, visual_depth = {}",
                  y_pos, y_block_depth, y_visual_depth);


        let result = format(src);
        eprintln!("Result:\n{}", result);
        assert!(result.contains("\n    [x, x * 2]"), "inner .do should have 4 spaces");
        assert!(result.contains("\n        y.postln"), "innermost body should have 8 spaces");
    }


    #[test]
    fn test_class_methods() {
        let src = r#"MyClass {
*new {
^super.new
}
}"#;


        // Debug: check depths for class members
        use crate::engine::ast_utils::{block_depth_at, visual_block_depth_at};
        use tree_sitter::Parser;
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
        eprintln!("'MyClass' at byte 0: block_depth = {}, visual_depth = {}",
                  myclass_block_depth, myclass_visual_depth);


        // Find position of "*new"
        let star_pos = src.find("*new").unwrap();
        let star_block_depth = block_depth_at(root, star_pos, bytes);
        let star_visual_depth = visual_block_depth_at(root, star_pos, bytes);
        eprintln!("'*new' at byte {}: block_depth = {}, visual_depth = {}",
                  star_pos, star_block_depth, star_visual_depth);


        // Debug: dump node ancestry
        if let Some(mut node) = root.descendant_for_byte_range(star_pos, star_pos + 1) {
            eprintln!("Node ancestry for '*new':");
            loop {
                eprintln!("  {} [{}..{}]", node.kind(), node.start_byte(), node.end_byte());
                if let Some(parent) = node.parent() {
                    node = parent;
                } else {
                    break;
                }
            }
        }


        let result = format(src);
        eprintln!("Result:\n{}", result);
        assert!(result.contains("\n    *new"), "*new should have 4 spaces");
        assert!(result.contains("\n        ^super"), "method body should have 8 spaces");
    }


    #[test]
    fn test_synthdef_body() {
        let src = r#"SynthDef(\test, { |freq|
var sig;
sig = SinOsc.ar(freq);
});"#;
        let result = format(src);
        eprintln!("Result:\n{}", result);
        assert!(result.contains("\n    var sig"), "SynthDef body should have 4 spaces");
    }


    #[test]
    fn debug_ast_indent_rule_execution() {
        let src = r#"// comment
(
var a = 1;
)
"#;
        let result = format(src);
        eprintln!("RESULT:\n'{}'", result);
        assert!(
            result.contains("\nvar a = 1;"),
            "var a should have 0 indent"
        );
    }


    #[test]
    fn test_multiline_function_call_pbind() {
        // This is the Pbind pattern that was failing
        let src = r#"e.stream = Pbind(
\degree, Pseq([0, 1, 2], inf),
\dur, 0.5
).asStream;"#;
        let result = format(src);
        eprintln!("Result:\n{}", result);
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
        let src = r#"SynthDef(\test,
{ |freq|
var sig;
sig = SinOsc.ar(freq);
});"#;
        let result = format(src);
        eprintln!("Result:\n{}", result);
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
        let src = r#"SinOsc.ar(440, 0, 0.1);"#;
        let result = format(src);
        eprintln!("Result:\n{}", result);
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
        eprintln!("Result:\n{}", result);
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
        let src = r#"Pdef(\test,
Pbind(
\degree, Pseq([0, 1, 2], inf),
\dur, 0.5
)
);"#;
        let result = format(src);
        eprintln!("Result:\n{}", result);
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
        eprintln!("Result:\n{}", result);
        // Switch cases should only be indented once
        assert!(
            result.contains("\n    0, {"),
            "Switch cases should be indented 4 spaces"
        );
    }


    #[test]
    fn test_array_in_function_call() {
        let src = r#"Synth(\test, [
freq, 440,
amp, 0.1
]);"#;
        let result = format(src);
        eprintln!("Result:\n{}", result);
        // Array contents should be indented once (inside the [...])
        // The param list shouldn't add another level because we're inside a collection
        assert!(
            result.contains("\n    freq, 440"),
            "Array contents in function call should be indented 4 spaces"
        );
    }
}
