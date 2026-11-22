use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

/// Try to rewrite an `if(cond, { ... }, { ... })` or `if(cond, { ... })` call,
/// given its `if` node. The tree, not the bytes, says where the condition and
/// the blocks are: a `,` or a bracket may be a character (`$,`) or in a string,
/// and the blank of `$ ` is not space to trim.
/// Returns (`start_byte`, `end_byte`, replacement) if successful.
fn rewrite_if_call(buf: &[u8], if_node: Node) -> Option<(usize, usize, String)> {
    let mut cursor = if_node.walk();
    let children: Vec<Node> = if_node.children(&mut cursor).collect();
    let text = |n: &Node| String::from_utf8_lossy(&buf[n.byte_range()]).to_string();

    // `if`, `(`, the condition up to the first `,`, then nothing but blocks
    // and commas to the `)` that ends the node. In the trailing form the node
    // ends with a block instead.
    let (open, rest) = children.split_first()?.1.split_first()?;
    if open.kind() != "(" || children.last()?.kind() != ")" {
        return None;
    }
    // A line comment among the call's own tokens would take in whatever is
    // written after it on its line: such a call is left as it is.
    if rest.iter().any(|n| n.kind() == "line_comment") {
        return None;
    }
    let comma = rest.iter().position(|n| n.kind() == ",")?;
    let (cond, args) = rest.split_at(comma);
    let blocks: Vec<String> = match args.iter().map(Node::kind).collect::<Vec<_>>()[..] {
        [",", "function_block", ")"] => vec![text(&args[1])],
        [",", "function_block", ",", "function_block", ")"] => {
            vec![text(&args[1]), text(&args[3])]
        }
        _ => return None,
    };
    let cond = String::from_utf8_lossy(&buf[cond.first()?.start_byte()..cond.last()?.end_byte()]);

    // Build replacement: `if (COND) { ... } [ { ... } ]`
    let mut repl = format!("if ({cond})");
    for block in blocks {
        repl.push(' ');
        repl.push_str(&block);
    }

    Some((if_node.start_byte(), if_node.end_byte(), repl))
}

/// The one child of `node`, when it has one and no more: no comma, no
/// semicolon, no comment beside it.
fn only_child(node: Node) -> Option<Node> {
    (node.child_count() == 1).then(|| node.child(0)).flatten()
}

/// The methods whose one argument, when it is a block, is written after
/// the call and not in its parentheses.
const BLOCK_METHODS: [&[u8]; 6] = [
    b"do", b"collect", b"select", b"reject", b"inject", b"detect",
];

/// Try to rewrite `.do({ ... })`, given its `method_call` node, as
/// `.do { ... }`: the one argument a block, and nothing else in the
/// parentheses. The same for the other methods above. The tree says so, as
/// it does for `if`.
/// Returns (`start_byte`, `end_byte`, replacement) for the `( ... )` part.
fn rewrite_block_call(buf: &[u8], call: Node) -> Option<(usize, usize, String)> {
    let name = call.child_by_field_name("name")?;
    if !BLOCK_METHODS.contains(&&buf[name.byte_range()]) {
        return None;
    }
    let mut cursor = call.walk();
    let children: Vec<Node> = call.children(&mut cursor).collect();
    // `.`, the name, `(`, the arguments, `)`
    let [_, _, open, arguments, close, ..] = children[..] else {
        return None;
    };
    if open.kind() != "(" || arguments.kind() != "parameter_call_list" || close.kind() != ")" {
        return None;
    }
    // parameter_call_list, argument_calls, unnamed_argument, the block
    let block = only_child(only_child(only_child(arguments)?)?)?;
    if block.kind() != "function_block" {
        return None;
    }
    let block = String::from_utf8_lossy(&buf[block.byte_range()]);
    Some((open.start_byte(), close.end_byte(), format!(" {block}")))
}

/// Try to rewrite `while({ test }, { body })`, given its `while` node, as
/// `while { test } { body }`.
/// Returns (`start_byte`, `end_byte`, replacement) for the `( ... )` part.
fn rewrite_while_call(buf: &[u8], while_node: Node) -> Option<(usize, usize, String)> {
    let mut cursor = while_node.walk();
    let children: Vec<Node> = while_node.children(&mut cursor).collect();
    let [keyword, open, condition, comma, body, end] = children[..] else {
        return None;
    };
    let kinds = [keyword, open, condition, comma, body, end].map(|n| n.kind());
    if kinds != ["while", "(", "function_block", ",", "function_block", ")"] {
        return None;
    }
    let text = |n: Node| String::from_utf8_lossy(&buf[n.byte_range()]).to_string();
    let replacement = format!(" {} {}", text(condition), text(body));
    Some((open.start_byte(), end.end_byte(), replacement))
}

/// The rewrites under `node`, outermost first. What stands inside a call
/// that is rewritten waits for the next pass: its edit would overlap.
fn collect_rewrites(buf: &[u8], node: Node, edits: &mut Vec<TextEdit>) {
    let rewrite = match node.kind() {
        "if" => rewrite_if_call(buf, node),
        "while" => rewrite_while_call(buf, node),
        "method_call" => rewrite_block_call(buf, node),
        _ => None,
    };
    if let Some((start_byte, end_byte, replacement)) = rewrite {
        edits.push(TextEdit {
            start_byte,
            end_byte,
            replacement,
        });
        return;
    }
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        collect_rewrites(buf, child, edits);
    }
}

pub struct TrailingClosures;
impl Rule for TrailingClosures {
    fn name(&self) -> &'static str {
        "trailing_closures"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        // Loop until no more transformations are found.
        // This handles nested patterns like `2.do({ 5.do({ ... }) })` where
        // the outer transformation on pass 1 skips the inner, which then gets
        // transformed on pass 2.
        let mut total_edits = 0;
        loop {
            let n = Self::run_pass(cx)?;
            if n == 0 {
                break;
            }
            total_edits += n;
        }
        Ok(total_edits)
    }
}

impl TrailingClosures {
    fn run_pass(cx: &mut Ctx) -> Result<usize> {
        let mut edits: Vec<TextEdit> = Vec::new();
        collect_rewrites(cx.bytes(), cx.tree.root_node(), &mut edits);

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
        TrailingClosures.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_do_with_one_block_in_parentheses_takes_it_as_a_trailing_block() {
        assert_eq!(format("3.do({ |i| i.postln });"), "3.do { |i| i.postln };");
        assert_eq!(format("a.do ( {1} );"), "a.do  {1};");
        assert_eq!(format("2.do({ 5.do({ 1 }) });"), "2.do { 5.do { 1 } };");
    }

    #[test]
    fn test_the_other_block_methods_and_while_take_trailing_blocks_too() {
        assert_eq!(
            format("a.collect({ |x| x * 2 });"),
            "a.collect { |x| x * 2 };"
        );
        assert_eq!(
            format("a.select({ 1 }).reject({ 2 });"),
            "a.select { 1 }.reject { 2 };"
        );
        assert_eq!(
            format("a.detect({ $) }).inject({ 3 });"),
            "a.detect { $) }.inject { 3 };"
        );
        assert_eq!(format("a.inject(0, { 3 });"), "a.inject(0, { 3 });");
        assert_eq!(
            format("while({ x < 10 }, { x = x + 1 });"),
            "while { x < 10 } { x = x + 1 };"
        );
        assert_eq!(format("while({ $} }, { $) });"), "while { $} } { $) };");
        assert_eq!(format("whilex({ 1 }, { 2 });"), "whilex({ 1 }, { 2 });");
        assert_eq!(format("while({ 1 }, { 2 }, 3);"), "while({ 1 }, { 2 }, 3);");
    }

    #[test]
    fn test_do_is_read_from_the_tree_not_the_bytes() {
        // A bracket or a comma in a character or a string is not the call's.
        assert_eq!(format("a.do({ $) });"), "a.do { $) };");
        assert_eq!(format("a.do({ \"}\" });"), "a.do { \"}\" };");
        assert_eq!(format("a.do({ $} });"), "a.do { $} };");
        // More than the one block, or anything beside it, is left alone.
        for src in [
            "a.do({ 1 }, 2);",
            "a.do({ 1 } /* why */);",
            "a.do(f);",
            "a.doIt({ 1 });",
            "a.do({ 1 };);",
            "\".do({ 1 })\";",
        ] {
            assert_eq!(format(src), src);
        }
    }

    #[test]
    fn test_an_if_with_a_line_comment_in_its_parentheses_is_left_alone() {
        let src = "if(a // why\n, { 1 }, { 2 });";
        assert_eq!(format(src), src);
        assert_eq!(
            format("if(a /* why */, { 1 }, { 2 });"),
            "if (a /* why */) { 1 } { 2 };"
        );
    }

    #[test]
    fn test_the_condition_keeps_the_character_space() {
        assert_eq!(
            format("if (char == $ , { 1 }, { 2 });"),
            "if (char == $ ) { 1 } { 2 };"
        );
    }

    #[test]
    fn test_brackets_and_commas_in_characters_and_strings_are_not_the_call() {
        assert_eq!(format("if(c == $,, {1}, {2});"), "if (c == $,) {1} {2};");
        assert_eq!(format("if(c == $(, {1});"), "if (c == $() {1};");
        assert_eq!(format("if(s == \")\", {1});"), "if (s == \")\") {1};");
        assert_eq!(format("if(a, { $} }, {2});"), "if (a) { $} } {2};");
    }
}
