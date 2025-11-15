pub mod engine;
pub mod rules;
pub mod grammar;

use anyhow::Result;

pub fn format_source(src: &str, phase: &str) -> Result<String> {
    let mut cx = engine::Ctx::new(src.to_string(), grammar::language())?;
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

