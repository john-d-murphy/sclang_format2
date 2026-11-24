use crate::engine::ast::tokens_of_kinds;
use crate::engine::text::{is_newline, is_space};
use crate::engine::{Ctx, TextEdit};
use crate::rules::Rule;
use anyhow::Result;

/// The names that are written with a space before their parenthesis.
const KEYWORDS: [&str; 5] = ["if", "while", "for", "switch", "case"];

/// Ensure exactly one ASCII space between keyword and '(' on the same line.
fn fix_keyword_paren(bytes: &[u8], i: usize, edits: &mut Vec<TextEdit>) {
    let len = bytes.len();
    if i >= len {
        return;
    }

    // skip spaces/tabs after the keyword, but stop at newline
    let mut l = i;
    while l < len && is_space(bytes[l]) && !is_newline(bytes[l]) {
        l += 1;
    }

    if l >= len || is_newline(bytes[l]) || bytes[l] != b'(' {
        // no '(' on this line right after keyword → don't touch
        return;
    }

    // We have: keyword [spaces?] '('
    if l == i {
        // no spaces currently, insert one
        edits.push(TextEdit {
            start_byte: i,
            end_byte: i,
            replacement: " ".to_string(),
        });
    } else if l - i != 1 {
        // more than one space, compress to exactly one
        edits.push(TextEdit {
            start_byte: i,
            end_byte: l,
            replacement: " ".to_string(),
        });
    }
    // else exactly one space already → do nothing
}

/// One space between a control structure's name and its parenthesis:
/// `if(a)` is `if (a)`.
pub struct KeywordParenSpacing;

impl Rule for KeywordParenSpacing {
    fn name(&self) -> &'static str {
        "keyword_paren_spacing"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        let bytes = cx.bytes();
        let mut edits = Vec::new();
        // The name where it is the control structure's own token, and where
        // it is the callee of a plain call (`if(a)` with one argument). As a
        // method's name after a dot (`x.if(a)`) or as a variable's it is
        // neither.
        let mut names = KEYWORDS.to_vec();
        names.push("method_name");
        for name in tokens_of_kinds(cx.tree.root_node(), &names) {
            let is_callee = name
                .parent()
                .and_then(|call| call.child_by_field_name("callee"))
                .is_some_and(|callee| callee.id() == name.id());
            let text = std::str::from_utf8(&bytes[name.byte_range()]).unwrap_or("");
            let after_a_dot = name.prev_sibling().is_some_and(|dot| dot.kind() == ".");
            if !after_a_dot
                && (name.kind() != "method_name" || (is_callee && KEYWORDS.contains(&text)))
            {
                fix_keyword_paren(bytes, name.end_byte(), &mut edits);
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
            &grammar::language(),
            IndentStyle::Spaces { width: 4 },
        )
        .unwrap();
        KeywordParenSpacing.run(&mut cx).unwrap();
        cx.to_string()
    }

    #[test]
    fn test_one_space_between_a_control_structures_name_and_its_parenthesis() {
        assert_eq!(format("if(a) { 1 };"), "if (a) { 1 };");
        assert_eq!(format("while   (a) { 1 };"), "while (a) { 1 };");
        assert_eq!(format("if(a);"), "if (a);");
    }

    #[test]
    fn test_a_method_or_a_variable_of_that_name_is_left_alone() {
        for src in [
            "x.if(a, b);",
            "x.while(a);",
            "if = 1; y = iffy(2);",
            "x.switch(a, b, c);",
        ] {
            assert_eq!(format(src), src);
        }
    }

    /// A rule that counts quotes is lost after a character that is one.
    #[test]
    fn test_a_quote_character_before_it_hides_no_keyword() {
        assert_eq!(format("x = $\"; if(a) { 1 };"), "x = $\"; if (a) { 1 };");
        assert_eq!(format("x = $'; if(a) { 1 };"), "x = $'; if (a) { 1 };");
    }
}
