//! The `if (condition) { a } { b }` whose condition and blocks are each on
//! one line: what the rule that joins one into a line and the rule that
//! parts one over lines both need to know, read from the tree and said once.

use crate::engine::Ctx;
use crate::engine::layout::make_indent;
use crate::engine::text::{is_newline, is_space};
use crate::rules::ast_indent::line_depth;
use tree_sitter::Node;

/// The widest a line may be with an `if` written on it whole.
const MAX_LINE_WIDTH: usize = 80;

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
        let on_one_line = |from: usize, to: usize| !bytes[from..to].iter().any(|&b| is_newline(b));
        let text = |from: usize, to: usize| {
            on_one_line(from, to)
                .then(|| std::str::from_utf8(&bytes[from..to]).ok())
                .flatten()
                .map(str::trim)
        };
        if !on_one_line(keyword.end_byte(), open.start_byte()) {
            return None;
        }
        let body = |block: Node| text(block.start_byte() + 1, block.end_byte() - 1);

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
            condition: text(open.end_byte(), close.start_byte())?,
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

    /// Whether the line would be too wide with this written on it whole. The
    /// line is measured as it will stand: the indent its depth gives it,
    /// what is before the `if` on its first line, the `if` on one line, and
    /// what follows it on its last. Both rules ask this and nothing else, so
    /// that one never undoes what the other did.
    pub fn is_too_wide_for_one_line(&self, cx: &Ctx) -> bool {
        let bytes = cx.bytes();
        let line_start = bytes[..self.start]
            .iter()
            .rposition(|&b| is_newline(b))
            .map_or(0, |at| at + 1);
        let first = bytes[line_start..self.start]
            .iter()
            .position(|&b| !is_space(b))
            .map_or(self.start, |at| line_start + at);
        let line_end = bytes[self.end..]
            .iter()
            .position(|&b| is_newline(b))
            .map_or(bytes.len(), |at| self.end + at);
        let indent = make_indent(
            cx.indent_style,
            line_depth(cx.tree.root_node(), bytes, first),
        );
        let width =
            indent.len() + (self.start - first) + self.on_one_line().len() + (line_end - self.end);
        width > MAX_LINE_WIDTH
    }
}
