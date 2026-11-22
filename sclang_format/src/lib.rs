#![deny(clippy::all)]
#![warn(clippy::pedantic)]
#![warn(clippy::cargo)]
#![warn(clippy::nursery)]

pub mod engine;
pub mod grammar;
pub mod rules;

use anyhow::Result;

pub use engine::IndentStyle;

/// `src` formatted.
///
/// # Errors
/// When `src` does not parse, or a rule breaks it.
pub fn format_source_with_indent(src: &str, indent_style: IndentStyle) -> Result<String> {
    let mut cx = engine::Ctx::new(src.to_string(), &grammar::language(), indent_style)?;
    rules::run(&mut cx)?;
    Ok(cx.to_string())
}

/// `src` formatted, indented by four spaces a level.
///
/// # Errors
/// When `src` does not parse, or a rule breaks it.
pub fn format_source(src: &str) -> Result<String> {
    format_source_with_indent(src, IndentStyle::Spaces { width: 4 })
}
