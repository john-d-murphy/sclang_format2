//! How wide a line will stand once the formatter is done with it. Every
//! rule that decides by the width of a line asks here, so that no two of
//! them measure differently and one undoes what another did.

use crate::engine::Ctx;
use crate::engine::layout::{MAX_LINE_WIDTH, columns};
use crate::engine::text::{is_newline, is_space};
use crate::rules::ast_indent::line_depth;

/// Where the text of the line that holds `at` begins: its first character
/// that is not a blank.
pub(super) fn text_start_of_line(bytes: &[u8], at: usize) -> usize {
    let line_start = bytes[..at]
        .iter()
        .rposition(|&b| is_newline(b))
        .map_or(0, |i| i + 1);
    bytes[line_start..at]
        .iter()
        .position(|&b| !is_space(b))
        .map_or(at, |i| line_start + i)
}

/// Where the text of the line that holds `at` ends: before the blanks that
/// end the line, which `trailing_whitespace` takes away. The blank of the
/// character `$ ` is the character, and stays.
pub(super) fn text_end_of_line(cx: &Ctx, at: usize) -> usize {
    let bytes = cx.bytes();
    let line_end = bytes[at..]
        .iter()
        .position(|&b| is_newline(b))
        .map_or(bytes.len(), |i| at + i);
    let mut end = line_end;
    while end > at && is_space(bytes[end - 1]) {
        end -= 1;
    }
    let in_a_character = |byte| {
        cx.tree
            .root_node()
            .descendant_for_byte_range(byte, byte + 1)
            .is_some_and(|n| n.kind() == "char")
    };
    if end < line_end && in_a_character(end) {
        end += 1;
    }
    end
}

/// Whether a line is too wide as it will stand: with the indent its depth
/// gives it, since `indent_by_ast_level` runs later and the indent the line
/// has now may be anything. `first` is where the line's text begins and
/// `text` is that text, in as many pieces as the rule that asks has it in.
pub(super) fn is_too_wide(cx: &Ctx, first: usize, text: &[&[u8]]) -> bool {
    let style = cx.indent_style;
    let indent = line_depth(cx.tree.root_node(), cx.bytes(), first) * style.width();
    let width: usize = text.iter().map(|part| columns(part, style)).sum();
    indent + width > MAX_LINE_WIDTH
}
