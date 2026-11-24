use crate::engine::Ctx;
use crate::rules::Rule;
use anyhow::{Result, bail};

/// Refuses text that does not parse: the first rule, before any other reads
/// the tree.
///
/// The formatter never repairs. A rule given a tree with an error in it
/// would work from what the parser guessed, and has been seen to drop the
/// parameter after a missing comma and write the rest out as sound code.
/// What sclang refuses must not come out as something sclang accepts.
pub struct ParseCheck;

impl Rule for ParseCheck {
    fn name(&self) -> &'static str {
        "parse_check"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        if let Some(line) = cx.error_line() {
            bail!("parse error at line {line}");
        }
        Ok(0)
    }
}

#[cfg(test)]
mod tests {
    /// Each of these is a syntax error to sclang, or text that sclang ends
    /// early at an open comment. The formatter refuses each, and none comes
    /// out as code.
    #[test]
    fn test_text_that_does_not_parse_is_refused_not_repaired() {
        for src in [
            "f = { arg a b; a + b };",
            "f = { arg a, b c = 2; a + b + c };",
            "f = { arg a = 1 2; a };",
            "f = { arg a, b = 1 + ; a };",
            "x = 1; // c\ny = 2 /* d",
            "f = { |a|-1 };",
            "f = { |a=-1| a };",
            "f = { |a|/*c*/ a };",
            "x = a+.2b;",
        ] {
            let formatted = crate::format_source(src);
            assert!(formatted.is_err(), "{src:?} came out as {formatted:?}");
        }
    }
}
