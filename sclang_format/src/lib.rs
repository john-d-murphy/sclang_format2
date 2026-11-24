#![deny(clippy::all)]
#![warn(clippy::pedantic)]
#![warn(clippy::cargo)]
#![warn(clippy::nursery)]

pub mod engine;
pub mod grammar;
mod regions;
pub mod rules;

use anyhow::{Result, bail};
use regions::Part;
use std::ops::Range;

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
    let mut out = String::with_capacity(src.len());
    for part in regions::parts(src, &regions)? {
        match part {
            Part::Region(region) => match program(&src[region.clone()])? {
                // Without the line break that ends a program.
                Ok(formatted) => out.push_str(formatted.trim_end_matches('\n')),
                Err(line) => bail!(
                    "parse error at line {}",
                    line + line_of(src, region.start) - 1
                ),
            },
            // Loose code that is a program: formatted, the blank lines
            // before and after it kept.
            Part::Loose {
                text,
                program: true,
            } => {
                let code = code_of(src, &text);
                match program(&src[code.clone()])? {
                    Ok(formatted) => {
                        let from = src[text.start..code.start]
                            .rfind('\n')
                            .map_or(text.start, |at| text.start + at + 1);
                        let to = src[code.end..text.end]
                            .find('\n')
                            .map_or(text.end, |at| code.end + at);
                        out.push_str(&src[text.start..from]);
                        out.push_str(formatted.trim_end_matches('\n'));
                        out.push_str(&src[to..text.end]);
                    }
                    Err(_) => out.push_str(&src[text]),
                }
            }
            Part::Loose { text, .. } | Part::AsWritten(text) => out.push_str(&src[text]),
        }
    }
    Ok(out)
}

/// The line `at` stands in, counted from 1.
fn line_of(src: &str, at: usize) -> usize {
    src[..at].matches('\n').count() + 1
}

/// The code within `text` of `src`: `text` without the blanks and blank
/// lines around it.
fn code_of(src: &str, text: &Range<usize>) -> Range<usize> {
    let within = &src[text.clone()];
    let start = text.start + within.len() - within.trim_start().len();
    start..(text.start + within.trim_end().len()).max(start)
}

/// What kind of unit a stretch of a file is.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum UnitKind {
    /// The whole file, which is one program.
    Program,
    /// A region of a file of regions.
    Region,
    /// Loose code between regions.
    Loose,
}

impl UnitKind {
    #[must_use]
    pub const fn name(self) -> &'static str {
        match self {
            Self::Program => "program",
            Self::Region => "region",
            Self::Loose => "loose",
        }
    }
}

/// A stretch of a file that is compiled or evaluated by itself.
#[derive(Debug, Clone)]
pub struct Unit {
    pub kind: UnitKind,
    /// Whether sclang is expected to take it as a program. False only for
    /// loose code the formatter leaves as it is written, and for a whole
    /// file that does not parse.
    pub program: bool,
    pub bytes: Range<usize>,
    /// Its first and last line, counted from 1.
    pub lines: (usize, usize),
}

/// The units of `src`, as the formatter reads it: the whole of it where it
/// is one program or has no regions, and otherwise its regions and its
/// loose code, in order.
///
/// # Errors
/// When a bracket is without its other, so that the regions cannot be told.
pub fn units(src: &str) -> Result<Vec<Unit>> {
    let unit = |kind, program, bytes: Range<usize>| Unit {
        kind,
        program,
        lines: (
            line_of(src, bytes.start),
            line_of(src, bytes.end.saturating_sub(1).max(bytes.start)),
        ),
        bytes,
    };
    let whole = |program| {
        vec![unit(
            UnitKind::Program,
            program,
            code_of(src, &(0..src.len())),
        )]
    };
    let parses = engine::Ctx::new(
        src.to_string(),
        &grammar::language(),
        IndentStyle::Spaces { width: 4 },
    )?
    .error_line()
    .is_none();
    if parses {
        return Ok(whole(true));
    }
    let regions = regions::of(src)?;
    if regions.is_empty() {
        return Ok(whole(false));
    }
    Ok(regions::parts(src, &regions)?
        .into_iter()
        .filter_map(|part| match part {
            Part::Region(bytes) => Some(unit(UnitKind::Region, true, bytes)),
            Part::Loose { text, program } => {
                Some(unit(UnitKind::Loose, program, code_of(src, &text)))
            }
            Part::AsWritten(_) => None,
        })
        .collect())
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
