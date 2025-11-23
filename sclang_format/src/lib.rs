#![deny(clippy::all)]
#![warn(clippy::pedantic)]
#![warn(clippy::cargo)]
#![warn(clippy::nursery)]

pub mod engine;
pub mod grammar;
pub mod rules;

use anyhow::Result;

pub use engine::IndentStyle;

pub fn format_source_with_indent(
    src: &str,
    phase: &str,
    indent_style: IndentStyle,
) -> Result<String> {
    let mut cx = engine::Ctx::new(src.to_string(), grammar::language(), indent_style)?;
    match phase {
        "pre" => rules::run_pre(&mut cx)?,
        "inline" => rules::run_inline(&mut cx)?,
        "post" => rules::run_post(&mut cx)?,
        "all" => {
            rules::run_pre(&mut cx)?;
            rules::run_inline(&mut cx)?;
            rules::run_post(&mut cx)?;
        }
        _ => {}
    }
    Ok(cx.to_string())
}

// Backwards-compatible helper: default to 4-space indent.
pub fn format_source(src: &str, phase: &str) -> Result<String> {
    format_source_with_indent(src, phase, IndentStyle::Spaces { width: 4 })
}
