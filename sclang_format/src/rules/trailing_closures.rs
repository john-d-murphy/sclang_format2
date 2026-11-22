use crate::engine::ast::in_string_or_comment;
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t' || b == b'\r' || b == b'\n'
}

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

/// Try to rewrite `.do({ ... })` at the given `dot` index (where buf[dot] == '.').
/// Returns (`start_byte`, `end_byte`, replacement) for the `( ... )` part.
fn rewrite_do_call(buf: &[u8], dot: usize) -> Option<(usize, usize, String)> {
    let len = buf.len();
    if dot + 3 >= len {
        return None;
    }
    if &buf[dot..dot + 3] != b".do" {
        return None;
    }

    // Skip whitespace after "do"
    let mut i = dot + 3;
    while i < len && is_space(buf[i]) {
        i += 1;
    }
    if i >= len || buf[i] != b'(' {
        return None;
    }
    let open = i;

    // Find matching ')', track nesting and commas.
    let mut paren = 1i32;
    let mut brace = 0i32;
    let mut bracket = 0i32;
    let mut commas = 0usize;
    let mut j = open + 1;
    let mut close_opt = None;

    while j < len {
        let c = buf[j];
        match c {
            b'(' => paren += 1,
            b')' => {
                paren -= 1;
                if paren == 0 {
                    close_opt = Some(j);
                    break;
                }
            }
            b'{' => brace += 1,
            b'}' => brace -= 1,
            b'[' => bracket += 1,
            b']' => bracket -= 1,
            b',' if paren == 1 && brace == 0 && bracket == 0 => {
                commas += 1;
            }
            _ => {}
        }
        j += 1;
    }

    let close = close_opt?;
    if commas > 0 {
        // more than one arg, don't touch
        return None;
    }

    // Inside the parentheses, expect exactly one block argument: { ... }
    let mut k = open + 1;
    while k < close && is_space(buf[k]) {
        k += 1;
    }
    if k >= close || buf[k] != b'{' {
        return None;
    }

    let block_start = k;
    let mut brace_depth = 1i32;
    k += 1;
    let mut block_end_opt = None;
    while k < close {
        let c = buf[k];
        match c {
            b'{' => brace_depth += 1,
            b'}' => {
                brace_depth -= 1;
                if brace_depth == 0 {
                    block_end_opt = Some(k);
                    break;
                }
            }
            _ => {}
        }
        k += 1;
    }

    let block_end = block_end_opt?;
    // After the block and before the closing ')', only whitespace is allowed.
    let mut t = block_end + 1;
    while t < close {
        if !is_space(buf[t]) {
            return None;
        }
        t += 1;
    }

    let block_str = String::from_utf8_lossy(&buf[block_start..=block_end]).to_string();
    let replacement = format!(" {block_str}");

    Some((open, close + 1, replacement))
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

        let bytes = cx.bytes();
        let buf: &[u8] = &bytes;
        let root = cx.tree.root_node();
        let len = buf.len();

        let mut edits: Vec<TextEdit> = Vec::new();
        let mut i = 0;

        while i < len {
            // First, try `if(...)` form: an `if` token that begins an `if` node.
            if i + 2 <= len
                && &buf[i..i + 2] == b"if"
                && let Some(token) = root.descendant_for_byte_range(i, i + 2)
                && token.kind() == "if"
                && let Some(if_node) = token.parent().filter(|n| n.kind() == "if")
                && let Some((start, end, repl)) = rewrite_if_call(buf, if_node)
            {
                edits.push(TextEdit {
                    start_byte: start,
                    end_byte: end,
                    replacement: repl,
                });
                // Skip past this call to avoid overlapping edits.
                i = end;
                continue;
            }

            // Then, try `.do({ ... })` form.
            if buf[i] == b'.'
                && !in_string_or_comment(root, i)
                && let Some((start, end, repl)) = rewrite_do_call(buf, i)
            {
                edits.push(TextEdit {
                    start_byte: start,
                    end_byte: end,
                    replacement: repl,
                });
                i = end;
                continue;
            }

            i += 1;
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
            grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        TrailingClosures.run(&mut cx).unwrap();
        cx.to_string()
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
