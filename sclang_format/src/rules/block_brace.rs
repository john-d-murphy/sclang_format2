// src/rules/block_brace.rs

use crate::engine::ast::end_of_token_before;
use crate::engine::text::{is_newline, is_space};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

fn fix_before_brace(bytes: &[u8], brace_node: Node, edits: &mut Vec<TextEdit>) {
    let brace = brace_node.start_byte();
    if brace == 0 {
        return;
    }

    // find start of whitespace run before '{', as far back as the token
    // before it: the blank of the character `$ ` is that token's
    let token_end = end_of_token_before(brace_node);
    let mut ws_start = brace;
    while ws_start > token_end && is_space(bytes[ws_start - 1]) {
        ws_start -= 1;
    }

    let Some(prev_index) = ws_start.checked_sub(1) else {
        return;
    };

    let prev = bytes[prev_index];
    if is_newline(prev) {
        // brace starts at beginning of line (after indentation); leave it
        return;
    }

    // Closed function syntax: #{ should stay together, no space
    if prev == b'#' {
        // Remove any whitespace between # and {
        if ws_start < brace {
            edits.push(TextEdit {
                start_byte: ws_start,
                end_byte: brace,
                replacement: String::new(),
            });
        }
        return;
    }

    // Block as first argument: ({ should stay together, no space
    // This covers apply calls like g.({...}) and function calls like foo({...})
    if prev == b'(' {
        // Remove any whitespace between ( and {
        if ws_start < brace {
            edits.push(TextEdit {
                start_byte: ws_start,
                end_byte: brace,
                replacement: String::new(),
            });
        }
        return;
    }

    // we want exactly one space between prev token and '{'
    if brace - ws_start == 1 && bytes[ws_start] == b' ' {
        // already exactly one space
        return;
    }

    edits.push(TextEdit {
        start_byte: ws_start,
        end_byte: brace,
        replacement: " ".to_string(),
    });
}

pub struct BlockBraceSpacing;

impl Rule for BlockBraceSpacing {
    fn name(&self) -> &'static str {
        "block_brace_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let mut edits = Vec::new();
        collect(cx.bytes(), cx.tree.root_node(), &mut edits);

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

/// Every opening brace the tree holds under `node`: a function's, a class's,
/// a list comprehension's. A brace in a string, a symbol, a character or a
/// comment is no token, and is not met.
fn collect(bytes: &[u8], node: Node, edits: &mut Vec<TextEdit>) {
    if matches!(node.kind(), "{" | "{:" | "{;") {
        fix_before_brace(bytes, node, edits);
    }
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        collect(bytes, child, edits);
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
        let rule = BlockBraceSpacing;
        rule.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_a_brace_in_a_character_a_symbol_or_a_string_is_not_a_block() {
        for src in [
            "x = [${, $}, $\", $'];\nf = { 1 };",
            "x = $';\nf{ 1 };\ny = $';",
            "x = '{';\ny = \"{\";",
            "x = ${;",
            "/* a{ */ x = 1; // b{",
        ] {
            let expected = src.replace("f{", "f {");
            assert_eq!(format(src), expected);
        }
    }

    #[test]
    fn test_a_list_comprehension_gets_its_space_too() {
        assert_eq!(format("all{: x, x <- y }"), "all {: x, x <- y }");
    }

    #[test]
    fn test_adds_space_before_brace() {
        assert_eq!(format("foo{ }"), "foo { }");
    }

    #[test]
    fn test_preserves_single_space() {
        assert_eq!(format("foo { }"), "foo { }");
    }

    #[test]
    fn test_normalizes_multiple_spaces() {
        assert_eq!(format("foo   { }"), "foo { }");
    }

    #[test]
    fn test_closed_function_no_space() {
        // #{ should stay together - no space between # and {
        assert_eq!(format("#{ 1 + 2 }"), "#{ 1 + 2 }");
    }

    #[test]
    fn test_closed_function_removes_space() {
        // Remove any existing space between # and {
        assert_eq!(format("# { 1 + 2 }"), "#{ 1 + 2 }");
    }

    #[test]
    fn test_closed_function_in_assignment() {
        assert_eq!(format("x = #{ ~dur }"), "x = #{ ~dur }");
    }

    #[test]
    fn test_closed_function_removes_space_in_assignment() {
        assert_eq!(format("x = # { ~dur }"), "x = #{ ~dur }");
    }

    #[test]
    fn test_block_as_argument_no_space() {
        // ({ should stay together - no space between ( and {
        assert_eq!(format("foo({ })"), "foo({ })");
    }

    #[test]
    fn test_block_as_argument_removes_space() {
        // Remove any existing space between ( and {
        assert_eq!(format("foo( { })"), "foo({ })");
    }

    #[test]
    fn test_apply_call_no_space() {
        // Apply calls g.({...}) should not have space after (
        assert_eq!(format("g.({ 1 + 2 })"), "g.({ 1 + 2 })");
    }

    #[test]
    fn test_apply_call_removes_space() {
        // Remove space between .( and {
        assert_eq!(format("g.( { 1 + 2 })"), "g.({ 1 + 2 })");
    }
}
