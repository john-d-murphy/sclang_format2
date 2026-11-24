//! SuperCollider's own class files, formatted: real files, long and written
//! by many hands, where the help snippets are short. Each file must be
//! parsed by the grammar, format without a rule breaking it, come out the
//! same from a second pass, and keep every token.
//!
//! - `class_library_formats_cleanly`: the class library as it is installed.
//!   Skips, saying so, when there is none.
//! - `test_suite_formats_cleanly`: the class files of SuperCollider's own
//!   test suite (testsuite/ in its source), which the installed library
//!   leaves out. Its scripts are the business of tests/sclang_judge.rs.
//!   Skips, saying so, when the source is not there; tests/common/mod.rs
//!   has where it is looked for and the command that fetches it.

mod common;

use common::tokens::changed_tokens;
use glob::glob;
use std::path::Path;
use tree_sitter::Parser;

const LIBRARY: &str = "/usr/share/SuperCollider/SCClassLibrary";

fn parses(parser: &mut Parser, src: &str) -> bool {
    !parser.parse(src, None).unwrap().root_node().has_error()
}

/// Formats every .sc file under `root` and requires each to be clean.
fn files_format_cleanly(root: &Path) {
    let mut parser = Parser::new();
    parser
        .set_language(&sclang_format::grammar::language())
        .unwrap();

    let mut paths: Vec<_> = glob(&format!("{}/**/*.sc", root.display()))
        .unwrap()
        .map(Result::unwrap)
        .collect();
    paths.sort();
    assert!(!paths.is_empty(), "no .sc files under {}", root.display());

    let mut faults = Vec::new();
    for path in &paths {
        let name = path.strip_prefix(root).unwrap().display().to_string();
        let input = std::fs::read_to_string(path).unwrap();
        if !parses(&mut parser, &input) {
            faults.push(format!("{name}: the grammar does not parse it"));
            continue;
        }
        let once = match sclang_format::format_source(&input) {
            Ok(out) => out,
            Err(e) => {
                faults.push(format!("{name}: refused: {e:#}"));
                continue;
            }
        };
        match sclang_format::format_source(&once) {
            Ok(twice) if twice != once => faults.push(format!("{name}: a second pass changes it")),
            Ok(_) => {}
            Err(e) => faults.push(format!("{name}: second pass refused: {e:#}")),
        }
        let changed = changed_tokens(&input, &once);
        if !changed.is_empty() {
            faults.push(format!("{name}: tokens changed: {}", changed.join(", ")));
        }
    }

    eprintln!(
        "{}: {} class files, {} faults",
        root.display(),
        paths.len(),
        faults.len()
    );
    assert!(faults.is_empty(), "\n{}", faults.join("\n"));
}

#[test]
fn class_library_formats_cleanly() {
    if !Path::new(LIBRARY).is_dir() {
        common::skip(
            "class_library_formats_cleanly",
            &format!("no class library at {LIBRARY}"),
        );
        return;
    }
    files_format_cleanly(Path::new(LIBRARY));
}

#[test]
fn test_suite_formats_cleanly() {
    let Some(source) = common::sc_source("test_suite_formats_cleanly") else {
        return;
    };
    files_format_cleanly(&source.join("testsuite"));
}
