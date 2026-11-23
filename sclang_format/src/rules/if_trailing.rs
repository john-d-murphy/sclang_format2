//! The `if (condition) { a } { b }` whose condition and blocks are each on
//! one line: what the rule that joins one into a line and the rule that
//! parts one over lines both need to know, read from the tree and said once.

use crate::engine::Ctx;
use crate::engine::text::{is_newline, is_space};
use crate::rules::width::{is_too_wide, text_end_of_line, text_start_of_line};
use tree_sitter::Node;

pub struct IfWithBlocks<'a> {
    /// Where the `if` begins.
    pub start: usize,
    /// Where it ends: after its last brace, or after the semicolon that
    /// follows that brace.
    pub end: usize,
    /// The condition and the two bodies, without the blanks around them.
    pub condition: &'a str,
    pub then_body: &'a str,
    pub else_body: &'a str,
    pub semicolon: bool,
}

impl<'a> IfWithBlocks<'a> {
    /// Reads `node` when it is an `if` with its condition in parentheses and
    /// two blocks after it, the condition and each block's body on one line.
    pub fn read(node: Node, bytes: &'a [u8]) -> Option<Self> {
        if node.kind() != "if" {
            return None;
        }
        let mut cursor = node.walk();
        let children: Vec<Node> = node.children(&mut cursor).collect();
        // `if`, `(`, the condition, `)` and the two blocks, with no comment
        // among them.
        let [keyword, open, .., close, then_block, else_block] = children[..] else {
            return None;
        };
        let is_block =
            |block: Node| block.kind() == "function_block" && bytes[block.start_byte()] == b'{';
        if keyword.kind() != "if"
            || open.kind() != "("
            || close.kind() != ")"
            || !is_block(then_block)
            || !is_block(else_block)
        {
            return None;
        }
        // What stands between two brackets, from its first token to its
        // last, when it is all on one line. The tokens say where it begins
        // and ends: its last byte may be the blank of the character `$ `,
        // which is no space to trim.
        let on_one_line = |from: usize, to: usize| !bytes[from..to].iter().any(|&b| is_newline(b));
        let between = |open: Node, close: Node| -> Option<&'a str> {
            if !on_one_line(open.end_byte(), close.start_byte()) {
                return None;
            }
            let (first, last) = (open.next_sibling()?, close.prev_sibling()?);
            if first.start_byte() >= close.start_byte() {
                return Some("");
            }
            std::str::from_utf8(&bytes[first.start_byte()..last.end_byte()]).ok()
        };
        if !on_one_line(keyword.end_byte(), open.start_byte()) {
            return None;
        }
        let body = |block: Node| between(block.child(0)?, block.child(block.child_count() - 1)?);

        let mut end = else_block.end_byte();
        while end < bytes.len() && is_space(bytes[end]) {
            end += 1;
        }
        let semicolon = bytes.get(end) == Some(&b';');
        Some(Self {
            start: node.start_byte(),
            end: if semicolon {
                end + 1
            } else {
                else_block.end_byte()
            },
            condition: between(open, close)?,
            then_body: body(then_block)?,
            else_body: body(else_block)?,
            semicolon,
        })
    }

    /// Whether it stands on one line as it is.
    pub fn is_on_one_line(&self, bytes: &[u8]) -> bool {
        !bytes[self.start..self.end].iter().any(|&b| is_newline(b))
    }

    /// Written on one line.
    pub fn on_one_line(&self) -> String {
        format!(
            "if ({}) {{ {} }} {{ {} }}{}",
            self.condition,
            self.then_body,
            self.else_body,
            if self.semicolon { ";" } else { "" }
        )
    }

    /// Whether the line would be too wide with this written on it whole:
    /// what is before the `if` on its first line, the `if` on one line, and
    /// what follows it on its last. Both rules ask this and nothing else, so
    /// that one never undoes what the other did.
    pub fn is_too_wide_for_one_line(&self, cx: &Ctx) -> bool {
        let bytes = cx.bytes();
        let first = text_start_of_line(bytes, self.start);
        is_too_wide(
            cx,
            first,
            &[
                &bytes[first..self.start],
                self.on_one_line().as_bytes(),
                &bytes[self.end..text_end_of_line(cx, self.end)],
            ],
        )
    }
}
