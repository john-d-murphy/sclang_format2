use crate::engine::Ctx;
use anyhow::Result;

pub trait Rule {
    fn name(&self) -> &'static str;
    fn run(&self, cx: &mut Ctx) -> Result<usize>;
}

// only include the modules you actually have:
mod assignment;
mod brace_pipes;
mod comma;
mod dot;
mod semicolon;
mod trailing_ws;

pub use assignment::AddSpacesAroundAssignment;
pub use brace_pipes::BraceAndPipesSingleLine;
pub use comma::AddSpacesAfterCommas;
pub use dot::NoSpacesAroundDot;
pub use semicolon::NoSpaceBeforeSemicolon;
pub use trailing_ws::TrimTrailingWhitespaceAndEofNewline;

pub fn run_pre(_cx: &mut Ctx) -> Result<()> {
    Ok(())
}

pub fn run_inline(cx: &mut Ctx) -> Result<()> {
    let rules: Vec<Box<dyn Rule>> = vec![
        Box::new(AddSpacesAfterCommas),
        Box::new(AddSpacesAroundAssignment),
        Box::new(NoSpaceBeforeSemicolon),
        Box::new(NoSpacesAroundDot),
        Box::new(BraceAndPipesSingleLine),
        //Box::new(TrimTrailingWhitespaceAndEofNewline),
    ];
    for r in rules {
        let _ = r.run(cx)?;
    }
    Ok(())
}

pub fn run_post(_cx: &mut Ctx) -> Result<()> {
    Ok(())
}

// re-export if rules want it
pub use crate::engine::Ctx as _CtxForRules;
pub use crate::engine::TextEdit as _TextEditForRules;
