use crate::engine::Ctx;
use anyhow::Result;

pub trait Rule {
    fn name(&self) -> &'static str;

    /// Applies the rule to the text of `cx`; how many edits it made.
    ///
    /// # Errors
    /// When its edits break the text (see `Ctx::apply_edits`).
    fn run(&self, cx: &mut Ctx) -> Result<usize>;
}

mod arg_to_pipe;
mod assignment;
mod ast_indent;
mod binary_ops;
mod block_brace;
mod block_layout;
mod brace_pipes;
mod call_index_paren;
mod colons;
mod comma;
mod compact_collections;
mod compact_if_trailing;
mod cuddle_else;
mod dot;
mod dot_chain_layout;
mod events_multiline;
mod expand_if_trailing;
mod if_trailing;
mod inline_comment_spacing;
mod inline_ws;
mod keyword_paren;
mod multiline_arrays;
mod no_final_semicolon;
mod parens_brackets;
mod parse_check;
mod pipe_body;
mod pipe_heads;
mod pipe_param_commas;
mod pipe_param_layout;
mod semicolon;
mod trailing_closures;
mod trailing_ws;
mod var_arg;

pub use arg_to_pipe::ArgToPipeParams;
pub use assignment::AddSpacesAroundAssignment;
pub use ast_indent::IndentByAstLevel;
pub use binary_ops::AddSpacesAroundBinaryOps;
pub use block_brace::BlockBraceSpacing;
pub use block_layout::BlockLayoutKAndR;
pub use brace_pipes::BraceAndPipesSingleLine;
pub use call_index_paren::CallIndexParenSpacing;
pub use colons::AddSpacesAroundColons;
pub use comma::AddSpacesAfterCommas;
pub use compact_collections::CompactShortCollections;
pub use compact_if_trailing::CompactShortIfTrailingClosures;
pub use cuddle_else::CuddleElse;
pub use dot::NoSpacesAroundDot;
pub use dot_chain_layout::DotChainLayout;
pub use events_multiline::MultiLineEventsOnePerLine;
pub use expand_if_trailing::ExpandLongIfTrailingClosures;
pub use inline_comment_spacing::InlineCommentSpacing;
pub use inline_ws::InlineWhitespaceFormat;
pub use keyword_paren::KeywordParenSpacing;
pub use multiline_arrays::MultiLineArrayElementsPerLine;
pub use no_final_semicolon::NoFinalSemicolon;
pub use parens_brackets::ParenBracketSpacing;
pub use parse_check::ParseCheck;
pub use pipe_body::PipeBodySpacing;
pub use pipe_heads::PipeHeadSpacing;
pub use pipe_param_commas::PipeParamAddMissingCommas;
pub use pipe_param_layout::PipeParamOnBraceLine;
pub use semicolon::NoSpaceBeforeSemicolon;
pub use trailing_closures::TrailingClosures;
pub use trailing_ws::TrimTrailingWhitespaceAndEofNewline;
pub use var_arg::VarAndArgSpacing;

/// Every rule, in order.
///
/// # Errors
/// When the text does not parse, or a rule breaks it; the error names the
/// rule.
pub fn run(cx: &mut Ctx) -> Result<()> {
    let rules: Vec<Box<dyn Rule>> = vec![
        // 0. Text that does not parse is refused before any rule reads it.
        Box::new(ParseCheck),
        // 1. The same code written another way
        Box::new(PipeParamAddMissingCommas),
        Box::new(ArgToPipeParams),
        Box::new(TrailingClosures),
        Box::new(CuddleElse),
        // 2. Structural layout (braces, dots, multi-line collection shape)
        Box::new(BlockLayoutKAndR),
        Box::new(PipeParamOnBraceLine),
        Box::new(BraceAndPipesSingleLine),
        Box::new(DotChainLayout),
        // 3. Width-aware 80-col logic (single-line vs multi-line decisions)
        Box::new(CompactShortCollections),
        // 4. Local spacing & punctuation
        Box::new(VarAndArgSpacing),
        Box::new(AddSpacesAfterCommas),
        Box::new(AddSpacesAroundColons),
        Box::new(AddSpacesAroundAssignment),
        Box::new(AddSpacesAroundBinaryOps),
        Box::new(ParenBracketSpacing),
        Box::new(CallIndexParenSpacing),
        Box::new(KeywordParenSpacing),
        Box::new(BlockBraceSpacing),
        Box::new(PipeHeadSpacing),
        Box::new(PipeBodySpacing),
        Box::new(NoSpacesAroundDot),
        Box::new(NoSpaceBeforeSemicolon),
        Box::new(InlineCommentSpacing),
        // 4b. The two if rules decide by the width of a line, so they come
        //     once its text is what it will be: spaced, and without the
        //     semicolons that end a block. Measured sooner, an if fits on one
        //     pass and not on the next, or the other way about.
        Box::new(NoFinalSemicolon),
        Box::new(CompactShortIfTrailingClosures),
        Box::new(ExpandLongIfTrailingClosures),
        // 4c. An array or an event that stands over several lines has one
        //     element to a line. After the if rules: an if that is parted
        //     makes the array that holds it one of these.
        Box::new(MultiLineEventsOnePerLine),
        Box::new(MultiLineArrayElementsPerLine),
        // 5. Indentation / global whitespace
        Box::new(IndentByAstLevel),
        Box::new(InlineWhitespaceFormat),
        // 6. Final clean-ups
        Box::new(TrimTrailingWhitespaceAndEofNewline),
    ];

    // Print initial state if DEBUG_RULES is set
    let debug = std::env::var("DEBUG_RULES").is_ok();
    if debug {
        eprintln!("\n{}", "=".repeat(60));
        eprintln!("INITIAL SOURCE");
        eprintln!("{}", "=".repeat(60));
        eprintln!("{}", String::from_utf8_lossy(cx.bytes()));
        eprintln!("{}\n", "=".repeat(60));
    }

    for r in rules {
        // Track the rule name in the context for debugging AST breaks
        cx.current_rule_name = Some(r.name());

        // Print after each rule
        if debug {
            eprintln!(">>> Running rule: {}", r.name());
            match r.run(cx) {
                Ok(edits) => {
                    eprintln!(">>> Finished Running rule: {}", r.name());
                    eprintln!("\n{}", "=".repeat(60));
                    eprintln!("After: {} ({} edits)", r.name(), edits);
                    eprintln!("{}", "=".repeat(60));
                    eprintln!("{}", String::from_utf8_lossy(cx.bytes()));
                    eprintln!("{}\n", "=".repeat(60));
                }
                Err(e) => {
                    eprintln!("Triggered by Rule: {}", r.name());
                    return Err(e.context(format!("rule {}", r.name())));
                }
            }
        } else if let Err(e) = r.run(cx) {
            eprintln!("Triggered by Rule: {}", r.name());
            return Err(e.context(format!("rule {}", r.name())));
        }
    }

    Ok(())
}
