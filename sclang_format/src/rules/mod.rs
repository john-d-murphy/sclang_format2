use crate::engine::Ctx;
use anyhow::Result;

pub trait Rule {
    fn name(&self) -> &'static str;
    fn run(&self, cx: &mut Ctx) -> Result<usize>;
}

mod assignment;
mod binary_ops;
mod block_brace;
mod block_layout;
mod brace_pipes;
mod call_index_paren;
mod colons;
mod comma;
mod dot;
mod dot_chain_layout;
mod indent_style;
mod inline_ws;
mod keyword_paren;
mod parens_brackets;
mod pipe_body;
mod pipe_heads;
mod semicolon;
mod trailing_ws;
mod var_arg;

pub use assignment::AddSpacesAroundAssignment;
pub use binary_ops::AddSpacesAroundBinaryOps;
pub use block_brace::BlockBraceSpacing;
pub use block_layout::BlockLayoutKAndR;
pub use brace_pipes::BraceAndPipesSingleLine;
pub use call_index_paren::CallIndexParenSpacing;
pub use colons::AddSpacesAroundColons;
pub use comma::AddSpacesAfterCommas;
pub use dot::NoSpacesAroundDot;
pub use dot_chain_layout::DotChainLayout;
pub use indent_style::IndentStyleRule;
pub use inline_ws::InlineWhitespaceFormat;
pub use keyword_paren::KeywordParenSpacing;
pub use parens_brackets::ParenBracketSpacing;
pub use pipe_body::PipeBodySpacing;
pub use pipe_heads::PipeHeadSpacing;
pub use semicolon::NoSpaceBeforeSemicolon;
pub use trailing_ws::TrimTrailingWhitespaceAndEofNewline;
pub use var_arg::VarAndArgSpacing;

pub fn run_pre(_cx: &mut Ctx) -> Result<()> {
    Ok(())
}

pub fn run_inline(cx: &mut Ctx) -> Result<()> {
    let rules: Vec<Box<dyn Rule>> = vec![
        // Line-Scoped Rules
        Box::new(AddSpacesAfterCommas),
        Box::new(AddSpacesAroundAssignment),
        Box::new(AddSpacesAroundBinaryOps),
        Box::new(AddSpacesAroundColons),
        Box::new(VarAndArgSpacing),
        Box::new(ParenBracketSpacing),
        Box::new(PipeHeadSpacing),
        Box::new(PipeBodySpacing),
        Box::new(CallIndexParenSpacing),
        Box::new(KeywordParenSpacing),
        Box::new(BlockBraceSpacing),
        Box::new(NoSpaceBeforeSemicolon),
        Box::new(NoSpacesAroundDot),
        Box::new(BraceAndPipesSingleLine),
        Box::new(TrimTrailingWhitespaceAndEofNewline),
        Box::new(InlineWhitespaceFormat),
        // Block-Scoped Rules
        Box::new(DotChainLayout),
        Box::new(BlockLayoutKAndR),
        Box::new(IndentStyleRule),
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
