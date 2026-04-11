// src/rules/block_brace.rs

use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

const fn is_space(b: u8) -> bool {
    b == b' ' || b == b'\t'
}

const fn is_newline(b: u8) -> bool {
    b == b'\n' || b == b'\r'
}

/// Check if the quote at `i` is escaped by an odd number of backslashes.
fn is_escaped(bytes: &[u8], i: usize) -> bool {
    let mut count = 0;
    let mut j = i;
    while j > 0 {
        j -= 1;
        if bytes[j] == b'\\' {
            count += 1;
        } else {
            break;
        }
    }
    count % 2 == 1
}

fn fix_before_brace(bytes: &[u8], brace: usize, edits: &mut Vec<TextEdit>) {
    if brace == 0 {
        return;
    }

    // find start of whitespace run before '{'
    let mut ws_start = brace;
    while ws_start > 0 && is_space(bytes[ws_start - 1]) && !is_newline(bytes[ws_start - 1]) {
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
        let src = cx.bytes();
        let bytes: &[u8] = &src;
        let len = bytes.len();

        let mut edits = Vec::new();

        let mut in_line_comment = false;
        let mut in_block_comment = false;
        let mut in_single_str = false;
        let mut in_double_str = false;

        let mut i = 0usize;
        while i < len {
            let b = bytes[i];

            // inside comments/strings
            if in_line_comment {
                if b == b'\n' {
                    in_line_comment = false;
                }
                i += 1;
                continue;
            }

            if in_block_comment {
                if b == b'*' && i + 1 < len && bytes[i + 1] == b'/' {
                    in_block_comment = false;
                    i += 2;
                } else {
                    i += 1;
                }
                continue;
            }

            if in_single_str {
                if b == b'\'' && !is_escaped(bytes, i) {
                    in_single_str = false;
                }
                i += 1;
                continue;
            }

            if in_double_str {
                if b == b'"' && !is_escaped(bytes, i) {
                    in_double_str = false;
                }
                i += 1;
                continue;
            }

            // entering comments/strings
            if b == b'/' && i + 1 < len {
                if bytes[i + 1] == b'/' {
                    in_line_comment = true;
                    i += 2;
                    continue;
                } else if bytes[i + 1] == b'*' {
                    in_block_comment = true;
                    i += 2;
                    continue;
                }
            }

            if b == b'\'' {
                in_single_str = true;
                i += 1;
                continue;
            }

            if b == b'"' {
                in_double_str = true;
                i += 1;
                continue;
            }

            // actual rule: '{' after some token on the same line
            if b == b'{' {
                fix_before_brace(bytes, i, &mut edits);
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
