use crate::engine::ast::end_of_token_before;
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::{Result, Ok};
use tree_sitter::{Query, QueryCursor, StreamingIterator};

pub struct NoSpaceBeforeSemicolon;

impl Rule for NoSpaceBeforeSemicolon {
    fn name(&self) -> &'static str {
        "NoSpaceBeforeSemicolon"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let root = cx.tree.root_node();
        let src = cx.bytes();
        let mut edits: Vec<TextEdit> = Vec::new();

        let q = Query::new(&cx.tree.language(), r#"( ";" ) @semi"#)?;
        let mut cur = QueryCursor::new();
        let mut it = cur.matches(&q, root, src);

        while let Some(m) = it.next() {
            let n = m.captures[0].node;
            let start = n.start_byte();
            let token_before_end = end_of_token_before(n);
            // remove spaces/tabs immediately before ';' (don’t cross newline)
            let mut j = start;
            while j > token_before_end && (src[j - 1] == b' ' || src[j - 1] == b'\t') {
                j -= 1;
            }
            if j < start && (j == 0 || src[j - 1] != b'\n') {
                edits.push(TextEdit {
                    start_byte: j,
                    end_byte: start,
                    replacement: String::new(),
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
    use crate::engine::IndentStyle;
    use crate::grammar;

    fn format(src: &str) -> String {
        let mut cx = Ctx::new(
            src.to_string(),
            grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        NoSpaceBeforeSemicolon.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_the_character_space_keeps_its_blank() {
        assert_eq!(format("x = 1 ;\ny = $ ;"), "x = 1;\ny = $ ;");
    }
}
