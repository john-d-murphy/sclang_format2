use anyhow::Result;
use tree_sitter::{Node, Query, QueryCursor, StreamingIterator};

use crate::engine::ast::in_string_or_comment;
use crate::engine::{Ctx, TextEdit};

pub struct BraceAndPipesSingleLine;

impl BraceAndPipesSingleLine {
    fn same_line(src: &[u8], a: usize, b: usize) -> bool {
        !src[a..b].contains(&b'\n')
    }

    /// One space inside each brace of a block that stands on one line:
    /// `{a}` is `{ a }`.
    fn space_block(src: &[u8], root: Node, blk: Node, edits: &mut Vec<TextEdit>) {
        let range = blk.byte_range();
        let open = range.start;
        let close = range.end - 1; // assuming '}' is last byte of the block

        if src.get(open) != Some(&b'{') || src.get(close) != Some(&b'}') {
            return;
        }
        if !Self::same_line(src, open, close) {
            return;
        }
        if in_string_or_comment(root, open) {
            return;
        }
        if Ctx::subtree_has_error(blk) {
            return;
        }

        // After '{' -> exactly one space (unless already before '|', both fine: we want "{ |")
        let mut after_l = open + 1;
        while after_l < src.len() && src[after_l].is_ascii_whitespace() && src[after_l] != b'\n' {
            after_l += 1;
        }
        if after_l == close {
            // An empty block: the space after '{' and the space before '}'
            // are the same gap, so it gets one edit, not the two below.
            if close != open + 2 {
                edits.push(TextEdit {
                    start_byte: open + 1,
                    end_byte: close,
                    replacement: " ".into(),
                });
            }
            return;
        }
        if after_l == open + 1 {
            edits.push(TextEdit {
                start_byte: after_l,
                end_byte: after_l,
                replacement: " ".into(),
            });
        } else if after_l > open + 2 {
            edits.push(TextEdit {
                start_byte: open + 1,
                end_byte: after_l,
                replacement: " ".into(),
            });
        }

        // Before '}' -> exactly one space (unless previous is '{', then "{ }" still okay)
        let mut before_r = close;
        while before_r > 0 && src[before_r - 1].is_ascii_whitespace() && src[before_r - 1] != b'\n'
        {
            before_r -= 1;
        }
        if before_r == close {
            edits.push(TextEdit {
                start_byte: before_r,
                end_byte: before_r,
                replacement: " ".into(),
            });
        } else if close - before_r != 1 {
            edits.push(TextEdit {
                start_byte: before_r,
                end_byte: close,
                replacement: " ".into(),
            });
        }
    }
}

impl crate::rules::Rule for BraceAndPipesSingleLine {
    fn name(&self) -> &'static str {
        "brace_pipe_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let src = bytes;
        let root = cx.tree.root_node();
        let lang = cx.tree.language();

        let mut edits = Vec::<TextEdit>::new();

        // function_block captures the whole `{ ... }`
        let q = Query::new(&lang, r"(function_block) @blk")?;
        let mut cur = QueryCursor::new();
        let mut caps = cur.captures(&q, root, src);

        while let Some((m, idx)) = caps.next() {
            Self::space_block(src, root, m.captures[*idx].node, &mut edits);
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
    use crate::rules::Rule;

    fn format(src: &str) -> String {
        let mut cx = Ctx::new(
            src.to_string(),
            &grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        BraceAndPipesSingleLine.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_an_empty_block_gets_one_space_however_it_came() {
        assert_eq!(format("x = {};"), "x = { };");
        assert_eq!(format("x = { };"), "x = { };");
        assert_eq!(format("x = {  };"), "x = { };");
        assert_eq!(format("foo(bar, {});"), "foo(bar, { });");
    }
}
