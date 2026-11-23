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
/// `regions`): each region is formatted as the program it is. So are the
/// lines between two regions where they are a program; where they are not
/// one, they are left as they are written.
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
    // Loose lines written out formatted, the blank lines before and after
    // them kept, where they are a program; `false`, and nothing written,
    // where they are not one or may be lines to evaluate one at a time.
    let formatted = |text: &str, out: &mut String| -> Result<bool> {
        let code = text.trim();
        let formatted = match program(code)? {
            Ok(formatted) if !code.is_empty() && !regions::reads_two_ways(code)? => formatted,
            _ => return Ok(false),
        };
        let from = text.len() - text.trim_start().len();
        let from = text[..from].rfind('\n').map_or(0, |at| at + 1);
        let to = text.trim_end().len();
        let to = text[to..].find('\n').map_or(text.len(), |at| to + at);
        out.push_str(&text[..from]);
        out.push_str(formatted.trim_end_matches('\n'));
        out.push_str(&text[to..]);
        Ok(true)
    };
    // The lines between two regions: formatted whole if they can be, and
    // if not, each paragraph of them that can be. The rest is left as it
    // is written.
    let loose = |text: &str, out: &mut String| -> Result<()> {
        if !formatted(text, out)? {
            for paragraph in regions::paragraphs(text) {
                if !formatted(paragraph, out)? {
                    out.push_str(paragraph);
                }
            }
        }
        Ok(())
    };

    let mut out = String::with_capacity(src.len());
    let mut done = 0;
    for region in regions {
        loose(&src[done..region.start], &mut out)?;
        match program(&src[region.clone()])? {
            // Without the line break that ends a program.
            Ok(formatted) => out.push_str(formatted.trim_end_matches('\n')),
            Err(line) => bail!(
                "parse error at line {}",
                line + src[..region.start].matches('\n').count()
            ),
        }
        // What shares the line of the `)` is left as it is written.
        done = regions::line_end(src, region.end);
        out.push_str(&src[region.end..done]);
    }
    loose(&src[done..], &mut out)?;
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
