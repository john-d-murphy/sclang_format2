// src/engine/layout.rs
use crate::engine::IndentStyle;

/// The widest a line may be, where no other width is asked for.
pub const DEFAULT_LINE_WIDTH: usize = 80;

/// The columns `text` takes on a line: one for a character, and for a tab as
/// many as a level of indent.
#[must_use]
pub fn columns(text: &[u8], style: IndentStyle) -> usize {
    text.iter()
        .map(|&b| match b {
            b'\t' => style.width(),
            // A byte that continues a character is no column of its own.
            0x80..=0xBF => 0,
            _ => 1,
        })
        .sum()
}

/// Info about a single line in the source.
#[derive(Debug, Clone)]
pub struct LineInfo<'a> {
    pub start: usize,
    pub end: usize,          // position of '\n' or len (exclusive)
    pub first_non_ws: usize, // first non-space/tab, or == end
    pub indent: &'a [u8],    // slice from start..first_non_ws
}

/// Iterator over lines in a byte slice.
///
/// Each item gives you line bounds and existing indentation.
pub struct LineCursor<'a> {
    src: &'a [u8],
    pos: usize,
}

impl<'a> LineCursor<'a> {
    #[must_use]
    pub const fn new(src: &'a [u8]) -> Self {
        Self { src, pos: 0 }
    }
}

impl<'a> Iterator for LineCursor<'a> {
    type Item = LineInfo<'a>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.pos >= self.src.len() {
            return None;
        }

        let len = self.src.len();
        let line_start = self.pos;
        let mut line_end = line_start;

        while line_end < len && self.src[line_end] != b'\n' {
            line_end += 1;
        }

        let mut first_non_ws = line_start;
        while first_non_ws < line_end {
            match self.src[first_non_ws] {
                b' ' | b'\t' => first_non_ws += 1,
                _ => break,
            }
        }

        let indent = &self.src[line_start..first_non_ws];

        // Move pos to next line (skip '\n' if present)
        self.pos = if line_end < len && self.src[line_end] == b'\n' {
            line_end + 1
        } else {
            line_end
        };

        Some(LineInfo {
            start: line_start,
            end: line_end,
            first_non_ws,
            indent,
        })
    }
}

/// Build an indent string for a given logical depth.
#[must_use]
pub fn make_indent(style: IndentStyle, depth: usize) -> String {
    match style {
        IndentStyle::Tabs => "\t".repeat(depth),
        IndentStyle::Spaces { width } => " ".repeat(depth * width),
    }
}
