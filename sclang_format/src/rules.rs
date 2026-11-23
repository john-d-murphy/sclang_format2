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
mod brace_pipes;
mod break_lines;
mod call_index_paren;
mod colons;
mod comma;
mod dot;
mod inline_comment_spacing;
mod inline_ws;
mod join_lines;
mod keyword_paren;
mod no_final_semicolon;
mod parens_brackets;
mod parse_check;
mod pipe_body;
mod pipe_heads;
mod pipe_param_commas;
mod reflow_comments;
mod semicolon;
mod trailing_closures;
mod trailing_ws;
mod var_arg;

pub use arg_to_pipe::ArgToPipeParams;
pub use assignment::AddSpacesAroundAssignment;
pub use ast_indent::IndentByAstLevel;
pub use binary_ops::AddSpacesAroundBinaryOps;
pub use block_brace::BlockBraceSpacing;
pub use brace_pipes::BraceAndPipesSingleLine;
pub use break_lines::BreakLines;
pub use call_index_paren::CallIndexParenSpacing;
pub use colons::AddSpacesAroundColons;
pub use comma::AddSpacesAfterCommas;
pub use dot::NoSpacesAroundDot;
pub use inline_comment_spacing::InlineCommentSpacing;
pub use inline_ws::InlineWhitespaceFormat;
pub use join_lines::JoinLines;
pub use keyword_paren::KeywordParenSpacing;
pub use no_final_semicolon::NoFinalSemicolon;
pub use parens_brackets::ParenBracketSpacing;
pub use parse_check::ParseCheck;
pub use pipe_body::PipeBodySpacing;
pub use pipe_heads::PipeHeadSpacing;
pub use pipe_param_commas::PipeParamAddMissingCommas;
pub use reflow_comments::ReflowComments;
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
        // 1. The same code written another way.
        // Parameters between pipes have a comma between each two.
        Box::new(PipeParamAddMissingCommas),
        // `arg a, b;` is written between pipes.
        Box::new(ArgToPipeParams),
        // A block that is the one argument of `do`, `collect` and the
        // like, and the blocks of an `if` or a `while` written as a call,
        // stand after the parentheses.
        Box::new(TrailingClosures),
        // 2. The layout, first half: the line breaks inside a statement
        //    are taken away. Before the rules for spacing, which make of
        //    the blank each leaves what they make of any blank.
        Box::new(JoinLines),
        // 3. Spacing and punctuation within a line.
        // One blank inside the braces of a block on one line.
        Box::new(BraceAndPipesSingleLine),
        // One blank after `var` and `arg`.
        Box::new(VarAndArgSpacing),
        // A blank after a comma and none before.
        Box::new(AddSpacesAfterCommas),
        // A blank after the colon of a key and none before.
        Box::new(AddSpacesAroundColons),
        // A blank each side of `=`.
        Box::new(AddSpacesAroundAssignment),
        // A blank each side of a binary operator.
        Box::new(AddSpacesAroundBinaryOps),
        // No blank inside parentheses and brackets.
        Box::new(ParenBracketSpacing),
        // No blank between what is called or indexed and its bracket.
        Box::new(CallIndexParenSpacing),
        // A blank between `if`, `while` and the like and their parenthesis.
        Box::new(KeywordParenSpacing),
        // A blank before the brace of a block, and none after `(` or `#`.
        Box::new(BlockBraceSpacing),
        // One blank between a block's brace and the pipes of its
        // parameters, and none inside the pipes.
        Box::new(PipeHeadSpacing),
        // One blank between the parameters and the body.
        Box::new(PipeBodySpacing),
        // No blank around the dot of a message.
        Box::new(NoSpacesAroundDot),
        // No blank before a semicolon.
        Box::new(NoSpaceBeforeSemicolon),
        // Two blanks before a comment that ends a line of code.
        Box::new(InlineCommentSpacing),
        // One blank, and no more, each side of every binary operator and
        // `=`.
        Box::new(InlineWhitespaceFormat),
        // The semicolon after the last statement of a block goes. Before
        // the layout, which measures the line without it.
        Box::new(NoFinalSemicolon),
        // 4. The layout, second half: each statement on a line, and one
        //    that does not fit in the line width broken, the outermost thing
        //    first. It measures the text the rules above leave.
        Box::new(BreakLines),
        // 5. Each line is indented as deep as the tree says it stands.
        Box::new(IndentByAstLevel),
        // 6. A paragraph of comments with a line too wide is filled again,
        //    where it now stands.
        Box::new(ReflowComments),
        // 7. No blanks at the end of a line, and one line break at the end
        //    of the file.
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
