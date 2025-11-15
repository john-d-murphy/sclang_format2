mod doc;
mod format;
mod grammar;

use anyhow::*;
use clap::Parser;
use owo_colors::OwoColorize;
use std::fs;
use std::io::{self, Read};
use tree_sitter::{Node, Parser as TsParser, Tree};

use sclang_format::format_source; // <-- crate name

#[derive(Parser, Debug)]
#[command(name = "sclang-format", version)]
struct Args {
    path: Option<String>,
    #[arg(long, default_value="all", value_parser = ["pre","inline","post","all"])]
    phase: String,
    #[arg(long)]
    write: bool,
}

fn read_input(path: &Option<String>) -> Result<String> {
    if let Some(p) = path {
        Ok(fs::read_to_string(p)?)
    } else {
        let mut buf = String::new();
        io::stdin().read_to_string(&mut buf)?;
        Ok(buf)
    }
}

fn parse_sclang(src: &str) -> Result<Tree> {
    let mut parser = TsParser::new();
    parser
        .set_language(&grammar::language())
        .context("failed to set supercollider language")?;
    parser.parse(src, None).context("parse failed")
}

fn print_tree(src: &str, tree: &Tree, max_depth: usize) {
    let root = tree.root_node();

    let root_kind_str = root.kind().cyan().bold().to_string();
    let has_errors_str = if root.has_error() {
        "true".red().bold().to_string()
    } else {
        "false".green().bold().to_string()
    };

    println!("{} {}", "root kind:".bold(), root_kind_str);
    println!("{} {}", "has errors:".bold(), has_errors_str);
    println!("{}", "---".bright_black());

    print_node(src, root, 0, 60, max_depth);
}

fn print_node(src: &str, node: Node, indent: usize, snippet_len: usize, max_depth: usize) {
    let indent_str = "  ".repeat(indent);

    let kind = node.kind();
    let range = node.byte_range();
    let start = node.start_position();
    let end = node.end_position();

    let raw = src.get(range.start..range.end).unwrap_or("");
    let first_line = raw.lines().next().unwrap_or("");
    let snippet: String = first_line.chars().take(snippet_len).collect();

    let is_err = node.is_error();
    let is_missing = node.is_missing();

    // --- kind & flags as Strings (avoid the type clash) ---

    let kind_display: String = if is_err {
        kind.red().bold().to_string()
    } else if is_missing {
        kind.yellow().bold().to_string()
    } else {
        kind.cyan().to_string()
    };

    let mut flags = String::new();
    if is_err {
        flags.push_str("[ERROR]");
    }
    if is_missing {
        if !flags.is_empty() {
            flags.push(' ');
        }
        flags.push_str("[MISSING]");
    }

    let flags_display: String = if !flags.is_empty() {
        if is_err {
            flags.red().bold().to_string()
        } else {
            flags.yellow().bold().to_string()
        }
    } else {
        String::new()
    };

    let coords_display = format!(
        "@ {}:{} - {}:{}",
        start.row + 1,
        start.column + 1,
        end.row + 1,
        end.column + 1
    )
    .blue()
    .to_string();

    let bytes_display = format!("bytes {}..{}", range.start, range.end)
        .magenta()
        .to_string();

    let snippet_display = snippet
        .replace('\t', "\\t")
        .replace('\n', "\\n")
        .bright_black()
        .to_string();

    println!(
        "{indent}{kind} {flags} {coords} {bytes} \"{snippet}\"",
        indent = indent_str,
        kind = kind_display,
        flags = flags_display,
        coords = coords_display,
        bytes = bytes_display,
        snippet = snippet_display,
    );

    if indent >= max_depth {
        return;
    }

    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        print_node(src, child, indent + 1, snippet_len, max_depth);
    }
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

//fn main() -> Result<()> {
//    let args = Args::parse();
//    let src = read_input(&args.path)?;
//    let tree = parse_sclang(&src)?;
//
//    if args.dump || !args.format {
//        print_tree(&src, &tree, args.max_depth);
//        return Ok(());
//    }
//
//    // --format: rewrite only pipe-argument lists
//    let rw = format::Rewriter::new(&src, &tree);
//    let out = rw.format_only_pipe_args()?;
//    print!("{out}");
//    Ok(())
//}
