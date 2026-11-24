#![deny(clippy::all)]
#![warn(clippy::pedantic)]
#![warn(clippy::cargo)]
#![warn(clippy::nursery)]

use anyhow::{Ok, Result};
use clap::{Parser, ValueEnum};
use std::fs;
use std::io::{self, Read};

use sclang_format::{IndentStyle, format_source_with};

#[derive(Debug, Clone, Copy, ValueEnum)]
enum IndentMode {
    Tabs,
    Spaces,
}

#[derive(Parser, Debug)]
#[command(name = "sclang-format", version)]
struct Args {
    path: Option<String>,

    #[arg(long)]
    write: bool,

    #[arg(long, value_enum, default_value_t = IndentMode::Spaces)]
    indent_mode: IndentMode,

    #[arg(long, default_value_t = 4)]
    indent_width: usize,

    /// The widest a line may be (as Black's --line-length)
    #[arg(long, default_value_t = 80)]
    line_length: usize,

    /// Format nothing: print the units of the file as one line of JSON (the
    /// whole program, or its regions and loose code)
    #[arg(long)]
    units: bool,
}

fn main() -> Result<()> {
    let args = Args::parse();
    let src = if let Some(p) = &args.path {
        fs::read_to_string(p)?
    } else {
        let mut s = String::new();
        io::stdin().read_to_string(&mut s)?;
        s
    };

    if args.units {
        let units: Vec<String> = sclang_format::units(&src)?
            .iter()
            .map(|unit| {
                format!(
                    r#"{{"kind":"{}","program":{},"start_byte":{},"end_byte":{},"start_line":{},"end_line":{}}}"#,
                    unit.kind.name(),
                    unit.program,
                    unit.bytes.start,
                    unit.bytes.end,
                    unit.lines.0,
                    unit.lines.1
                )
            })
            .collect();
        println!("[{}]", units.join(","));
        return Ok(());
    }

    let indent_style = match args.indent_mode {
        IndentMode::Tabs => IndentStyle::Tabs,
        IndentMode::Spaces => IndentStyle::Spaces {
            width: args.indent_width,
        },
    };

    let out = format_source_with(&src, indent_style, args.line_length)?;
    if args.write
        && let Some(p) = args.path
    {
        fs::write(p, &out)?;
        return Ok(());
    }
    print!("{out}");
    Ok(())
}
