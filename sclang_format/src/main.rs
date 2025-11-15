
use anyhow::*;
use clap::Parser;
use std::fs;
use std::io::{self, Read};

use sclang_format::format_source;

#[derive(Parser, Debug)]
#[command(name = "sclang-format", version)]
struct Args {
    path: Option<String>,
    #[arg(long, default_value="all", value_parser = ["pre","inline","post","all"])]
    phase: String,
    #[arg(long)]
    write: bool,
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
    let out = format_source(&src, &args.phase)?;
    if args.write {
        if let Some(p) = args.path {
            fs::write(p, &out)?;
            return Ok(());
        }
    }
    print!("{out}");
    Ok(())
}

