// src/rules/call_index_paren.rs
use crate::engine::ast::{blanks_before, tokens_of_kinds};
use crate::engine::text::{is_ident_char, is_newline};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;
use tree_sitter::Node;

fn is_keyword(bytes: &[u8], start: usize, end: usize) -> bool {
    let word = &bytes[start..end];
    word == b"if" || word == b"while" || word == b"for" || word == b"switch" || word == b"case"
}

fn fix_before_delim(bytes: &[u8], delim_node: Node, edits: &mut Vec<TextEdit>) {
    let delim = delim_node.start_byte();

    // find start of whitespace run before the delimiter
    let ws_start = blanks_before(bytes, delim_node);
    if ws_start == delim {
        // no spaces immediately before '(' / '[' on this line
        return;
    }

    let Some(prev_index) = ws_start.checked_sub(1) else {
        return;
    };

    let prev = bytes[prev_index];
    if is_newline(prev) {
        // '(' / '[' is at start of line (after indentation) – don't join
        return;
    }

    let mut call_like = false;

    if is_ident_char(prev) {
        // previous token is an identifier – check if it's a control keyword
        let mut word_start = prev_index;
        while word_start > 0 && is_ident_char(bytes[word_start - 1]) {
            word_start -= 1;
        }

        if is_keyword(bytes, word_start, prev_index + 1) {
            // keep `if (`, `while (`, etc.
            return;
        }

        call_like = true;
    } else if prev == b')' || prev == b']' || prev == b'}' {
        // e.g. foo().bar( ... ), array[0]( ... )
        call_like = true;
    }

    if !call_like {
        // e.g. '* (', '&& (', '+ (', etc. – leave spacing alone
        return;
    }

    // Now we know it's a call/index, so remove the spaces.
    edits.push(TextEdit {
        start_byte: ws_start,
        end_byte: delim,
        replacement: String::new(),
    });
}

/// No space between what is called or indexed and its bracket: `foo (1)` is
/// `foo(1)` and `a [0]` is `a[0]`.
pub struct CallIndexParenSpacing;

impl Rule for CallIndexParenSpacing {
    fn name(&self) -> &'static str {
        "call_index_paren_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let mut edits = Vec::new();
        for delim in tokens_of_kinds(cx.tree.root_node(), &["(", "["]) {
            fix_before_delim(bytes, delim, &mut edits);
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
            &grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        CallIndexParenSpacing.run(&mut cx).unwrap();
        cx.to_string()
    }

    /// A rule that counts quotes or brackets is lost after a character that
    /// is one. The tokens of the tree are what they are wherever they stand.
    #[test]
    fn test_a_quote_or_bracket_character_before_it_hides_nothing() {
        assert_eq!(
            format("x = $\"; y = foo (1); z = a [0];"),
            "x = $\"; y = foo(1); z = a[0];"
        );
        assert_eq!(format("x = $'; y = foo (1);"), "x = $'; y = foo(1);");
        assert_eq!(format("x = [$(, a (1)];"), "x = [$(, a(1)];");
    }
}
