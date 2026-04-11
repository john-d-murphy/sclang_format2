// src/engine/width.rs
use crate::engine::layout::LineInfo;

/// Configuration for column-width calculations.
#[derive(Debug, Clone, Copy)]
pub struct WidthConfig {
    /// Maximum allowed columns for a line (e.g. 80).
    pub max_cols: usize,
    /// How many columns a `\t` should count as.
    pub tab_width: usize,
}

impl Default for WidthConfig {
    fn default() -> Self {
        Self {
            max_cols: 80,
            tab_width: 4,
        }
    }
}

/// Compute the visual width of a line (excluding trailing newline).
pub fn line_width(src: &[u8], line: &LineInfo<'_>, cfg: &WidthConfig) -> usize {
    let mut cols = 0usize;
    let mut i = line.start;

    while i < line.end {
        let b = src[i];
        match b {
            b'\t' => {
                // advance to next tab stop
                let w = cfg.tab_width;
                let rem = cols % w;
                cols += if rem == 0 { w } else { w - rem };
            }
            _ => cols += 1,
        }
        i += 1;
    }

    cols
}

/// Would rendering `src[start..end]` on a line with `indent_cols` columns
/// keep us under `max_cols`?
pub fn span_fits_on_line(
    src: &[u8],
    start: usize,
    end: usize,
    indent_cols: usize,
    cfg: &WidthConfig,
) -> bool {
    // naive: count bytes, treating tab as tab_width
    let mut cols = indent_cols;
    let mut i = start;

    while i < end {
        let b = src[i];
        match b {
            b'\t' => {
                let w = cfg.tab_width;
                let rem = cols % w;
                cols += if rem == 0 { w } else { w - rem };
            }
            b'\n' => break,
            _ => cols += 1,
        }
        if cols > cfg.max_cols {
            return false;
        }
        i += 1;
    }

    true
}
