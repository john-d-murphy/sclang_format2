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

/// Try to rewrite `.do({ ... })`, given its `method_call` node, as
/// `.do { ... }`: the one argument a block, and nothing else in the
/// parentheses. The tree says so, as it does for `if` above.
/// Returns (`start_byte`, `end_byte`, replacement) for the `( ... )` part.
fn rewrite_do_call(buf: &[u8], call: Node) -> Option<(usize, usize, String)> {
    let name = call.child_by_field_name("name")?;
    if &buf[name.byte_range()] != b"do" {
        return None;
    }
    let mut cursor = call.walk();
    let children: Vec<Node> = call.children(&mut cursor).collect();
    // `.`, `do`, `(`, the arguments, `)`
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

/// The rewrites under `node`, outermost first. What stands inside a call
/// that is rewritten waits for the next pass: its edit would overlap.
fn collect_rewrites(buf: &[u8], node: Node, edits: &mut Vec<TextEdit>) {
    let rewrite = match node.kind() {
        "if" => rewrite_if_call(buf, node),
        "method_call" => rewrite_do_call(buf, node),
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
            let n = self.run_pass(cx)?;
            if n == 0 {
                break;
            }
            total_edits += n;
        }
        Ok(total_edits)
    }
}

impl TrailingClosures {
    fn run_pass(&self, cx: &mut Ctx) -> Result<usize> {
        // Don't rewrite closures on broken trees — byte-level rewrites
        // will produce garbage if the AST doesn't match the source.
        if cx.tree.root_node().has_error() {
            return Ok(0);
        }

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
            grammar::language(),
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
        assert_eq!(
            format("2.do({ 5.do({ 1 }) });"),
            "2.do { 5.do { 1 } };"
        );
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
