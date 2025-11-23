#![deny(clippy::all)]
#![warn(clippy::pedantic)]
#![warn(clippy::cargo)]
#![warn(clippy::nursery)]

use anyhow::*;
use clap::{Parser, ValueEnum};
use std::fs;
use std::io::{self, Read};

use sclang_format::{IndentStyle, format_source_with_indent};

#[derive(Debug, Clone, Copy, ValueEnum)]
enum IndentMode {
    Tabs,
    Spaces,
}

#[derive(Parser, Debug)]
#[command(name = "sclang-format", version)]
struct Args {
    path: Option<String>,

    #[arg(long, default_value="all", value_parser = ["pre","inline","post","all"])]
    phase: String,

    #[arg(long)]
    write: bool,

    #[arg(long, value_enum, default_value_t = IndentMode::Spaces)]
    indent_mode: IndentMode,

    #[arg(long, default_value_t = 4)]
    indent_width: usize,
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

    let indent_style = match args.indent_mode {
        IndentMode::Tabs => IndentStyle::Tabs,
        IndentMode::Spaces => IndentStyle::Spaces {
            width: args.indent_width,
        },
    };

    let out = format_source_with_indent(&src, &args.phase, indent_style)?;
    if args.write
        && let Some(p) = args.path
    {
        fs::write(p, &out)?;
        return Ok(());
    }
    print!("{out}");
    Ok(())
}
