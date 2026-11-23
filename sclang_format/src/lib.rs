#![deny(clippy::all)]
#![warn(clippy::pedantic)]
#![warn(clippy::cargo)]
#![warn(clippy::nursery)]

pub mod engine;
pub mod grammar;
pub mod rules;

use anyhow::Result;

pub use engine::IndentStyle;

/// `src` formatted, with no line wider than `line_width` that can be broken.
///
/// # Errors
/// When `src` does not parse, or a rule breaks it.
pub fn format_source_with(
    src: &str,
    indent_style: IndentStyle,
    line_width: usize,
) -> Result<String> {
    let mut cx = engine::Ctx::new(src.to_string(), &grammar::language(), indent_style)?;
    cx.line_width = line_width;
    rules::run(&mut cx)?;
    Ok(cx.to_string())
}

/// `src` formatted, indented by four spaces a level, to the default width.
///
/// # Errors
/// When `src` does not parse, or a rule breaks it.
pub fn format_source(src: &str) -> Result<String> {
    format_source_with(
        src,
        IndentStyle::Spaces { width: 4 },
        engine::layout::DEFAULT_LINE_WIDTH,
    )
}
