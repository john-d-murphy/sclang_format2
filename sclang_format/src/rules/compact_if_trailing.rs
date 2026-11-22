use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use crate::rules::if_trailing::IfWithBlocks;
use anyhow::Result;
use tree_sitter::Node;

/// Joins an `if (condition) { a } { b }` that stands over several lines
/// into one line, when the line is not too wide with it.
pub struct CompactShortIfTrailingClosures;

impl Rule for CompactShortIfTrailingClosures {
    fn name(&self) -> &'static str {
        "compact_short_if_trailing_closures"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let mut edits = Vec::new();
        collect(cx, cx.tree.root_node(), &mut edits);

        let n = edits.len();
        if n > 0 {
            cx.apply_edits(edits)?;
        }
        Ok(n)
    }
}

/// The ifs under `node` to join, outermost first: one that is joined takes
/// what it holds onto its line as it is.
fn collect(cx: &Ctx, node: Node, edits: &mut Vec<TextEdit>) {
    if let Some(found) = IfWithBlocks::read(node, cx.bytes())
        && !found.is_on_one_line(cx.bytes())
        && !found.is_too_wide_for_one_line(cx)
    {
        edits.push(TextEdit {
            start_byte: found.start,
            end_byte: found.end,
            replacement: found.on_one_line(),
        });
        return;
    }
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        collect(cx, child, edits);
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
        CompactShortIfTrailingClosures.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_both_blocks_get_a_space_inside_each_brace() {
        assert_eq!(format("x = if (a)\n{ 1 }\n{ 2 };"), "x = if (a) { 1 } { 2 };");
    }
}
