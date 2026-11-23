#![deny(clippy::all)]
#![warn(clippy::pedantic)]
#![warn(clippy::cargo)]
#![warn(clippy::nursery)]

pub mod engine;
pub mod grammar;
mod regions;
pub mod rules;

use anyhow::{Result, bail};

pub use engine::IndentStyle;

/// `src` formatted, with no line wider than `line_width` that can be broken.
///
/// A file that is no one program is taken as a file of regions (see
/// `regions`): each region is formatted as the program it is, and what
/// stands between the regions is left as it is written.
///
/// # Errors
/// When `src` does not parse, or a rule breaks it.
pub fn format_source_with(
    src: &str,
    indent_style: IndentStyle,
    line_width: usize,
) -> Result<String> {
    // `text` formatted as one program, or the line where it fails to parse.
    let program = |text: &str| -> Result<std::result::Result<String, usize>> {
        let mut cx = engine::Ctx::new(text.to_string(), &grammar::language(), indent_style)?;
        if let Some(line) = cx.error_line() {
            return Ok(Err(line));
        }
        cx.line_width = line_width;
        rules::run(&mut cx)?;
        Ok(Ok(cx.to_string()))
    };

    let line = match program(src)? {
        Ok(formatted) => return Ok(formatted),
        Err(line) => line,
    };
    let regions = regions::of(src)?;
    if regions.is_empty() {
        bail!("parse error at line {line}");
    }
    let mut out = String::with_capacity(src.len());
    let mut done = 0;
    for region in regions {
        out.push_str(&src[done..region.start]);
        match program(&src[region.clone()])? {
            // Without the line break that ends a program.
            Ok(formatted) => out.push_str(formatted.trim_end_matches('\n')),
            Err(line) => bail!(
                "parse error at line {}",
                line + src[..region.start].matches('\n').count()
            ),
        }
        done = region.end;
    }
    out.push_str(&src[done..]);
    Ok(out)
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
