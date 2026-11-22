//! sclang, SuperCollider's own compiler, as the judge of what is SuperCollider.
//!
//! `tests/judge.scd` compiles files (it never runs them) and posts what sclang
//! made of each; this file drives it. Both tests need sclang and skip, saying
//! so, when it is not installed.
//!
//! - `formatting_keeps_meaning` runs with plain `cargo test`: every corpus
//!   file sclang accepts must, once formatted, be accepted again and compile
//!   to the same thing.
//! - `corpus_design` needs python3 and the SuperCollider help sources as
//!   well, so it runs only when asked for:
//!
//!       cargo test --test sclang_judge -- --ignored --nocapture
//!
//!   It cuts every form from the help with `extract_help_from_docs.py
//!   --candidates`, has sclang judge them, and requires `tests/sc_help` to be
//!   exactly the forms sclang accepts, less those with characters outside
//!   ASCII in their code: the same files, the same text. What differs is
//!   listed under `target/judge/design/`.

mod common;

use common::judge::{
    Verdict, compile_all, declare, fresh_dir, judge, manifest_dir, par_map, sclang_installed, tally,
};
use std::collections::BTreeMap;
use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

/// Corpus files whose formatted text sclang compiles to something else, or
/// refuses. Each is a formatter bug or a grammar gap. The test tolerates
/// exactly these; one that stops differing must be removed. To list them
/// afresh, run this test and read `target/judge/meaning/differences.txt`,
/// which gives each differing file with both compilations or sclang's error:
///
///     cargo test --test sclang_judge formatting_keeps_meaning -- --test-threads=8
const KNOWN_MEANING_CHANGES: &[&str] = &[];

#[test]
fn formatting_keeps_meaning() {
    if !sclang_installed() {
        eprintln!("Skipping formatting_keeps_meaning: sclang is not installed");
        return;
    }
    let corpus = manifest_dir().join("tests/sc_help");
    let work = fresh_dir(&manifest_dir().join("target/judge/meaning"));
    let verdicts = judge(&corpus, &work);

    // Each accepted file, formatted, with the same names declared in front.
    let formatted_dir = fresh_dir(&work.join("formatted"));
    let accepted: Vec<(&PathBuf, &String, &Vec<String>)> = verdicts
        .iter()
        .filter_map(|(path, verdict)| match verdict {
            Verdict::Accepted { dump, declared } => Some((path, dump, declared)),
            Verdict::Refused { .. } => None,
        })
        .collect();
    let written = par_map(&accepted, |(path, _, declared)| {
        let text = fs::read_to_string(corpus.join(path)).unwrap();
        // A file the formatter refuses is the corpus test's business.
        let formatted = sclang_format::format_source(&text, "all").ok()?;
        let out = formatted_dir.join(path);
        fs::create_dir_all(out.parent().unwrap()).unwrap();
        let formatted = if declared.is_empty() {
            formatted
        } else {
            declare(declared, &formatted)
        };
        fs::write(out, formatted).unwrap();
        Some(())
    });
    let originals: BTreeMap<&PathBuf, &String> = accepted
        .iter()
        .zip(written)
        .filter_map(|((path, dump, _), written)| written.map(|()| (*path, *dump)))
        .collect();
    let mut formatted = compile_all(&formatted_dir, &work);

    let mut differing = BTreeMap::new();
    for (path, original) in &originals {
        let name = format!("tests/sc_help/{}", path.display());
        let compiled = formatted.remove(*path).unwrap();
        match compiled.dump {
            Some(dump) if dump == **original => {}
            Some(dump) => {
                differing.insert(name, format!("original:  {original}\nformatted: {dump}"));
            }
            None => {
                differing.insert(
                    name,
                    format!("refused once formatted: {}", compiled.errors.join(" | ")),
                );
            }
        }
    }
    let report: String = differing
        .iter()
        .map(|(name, how)| format!("{name}\n{how}\n\n"))
        .collect();
    fs::write(work.join("differences.txt"), report).unwrap();

    let unexpected: Vec<&String> = differing
        .keys()
        .filter(|name| !KNOWN_MEANING_CHANGES.contains(&name.as_str()))
        .collect();
    let stale: Vec<&&str> = KNOWN_MEANING_CHANGES
        .iter()
        .filter(|name| !differing.contains_key(**name))
        .collect();

    eprintln!("\n=== Formatting keeps meaning ===");
    eprintln!("Corpus: {}", tally(&verdicts));
    eprintln!("Compared: {}", originals.len());
    eprintln!(
        "Differing: {} ({} known)",
        differing.len(),
        differing.len() - unexpected.len()
    );
    eprintln!("Details: {}", work.join("differences.txt").display());

    assert!(
        stale.is_empty(),
        "KNOWN_MEANING_CHANGES lists files that no longer differ; remove them:\n{}",
        stale.iter().map(|s| format!("  {s}\n")).collect::<String>()
    );
    assert!(
        unexpected.is_empty(),
        "{} corpus files mean something else once formatted (see {}):\n{}",
        unexpected.len(),
        work.join("differences.txt").display(),
        unexpected
            .iter()
            .map(|s| format!("  {s}\n"))
            .collect::<String>()
    );
}

/// Whether `text` holds a character outside ASCII anywhere but in a string,
/// a quoted symbol or a comment. sclang's lexer skips such bytes, so it
/// accepts prose in Japanese or `z = ±1`; the corpus leaves those forms out.
/// The same reading as `non_ascii_in_code` in extract_help_from_docs.py.
fn non_ascii_in_code(text: &str) -> bool {
    let chars: Vec<char> = text.chars().collect();
    let at = |i: usize, s: &str| s.chars().enumerate().all(|(k, c)| chars.get(i + k) == Some(&c));
    let (mut i, n) = (0, chars.len());
    while i < n {
        if at(i, "//") {
            while i < n && chars[i] != '\n' {
                i += 1;
            }
        } else if at(i, "/*") {
            // Block comments nest in SuperCollider.
            let mut depth = 1;
            i += 2;
            while i < n && depth > 0 {
                if at(i, "/*") {
                    depth += 1;
                    i += 2;
                } else if at(i, "*/") {
                    depth -= 1;
                    i += 2;
                } else {
                    i += 1;
                }
            }
        } else if chars[i] == '"' || chars[i] == '\'' {
            let quote = chars[i];
            i += 1;
            while i < n && chars[i] != quote {
                i += if chars[i] == '\\' { 2 } else { 1 };
            }
            i += 1;
        } else if !chars[i].is_ascii() {
            return true;
        } else if chars[i] == '$' {
            // A character literal: `$"` opens no string, and `$é` is code.
            i += if at(i, "$\\") { 2 } else { 1 };
            if i < n && !chars[i].is_ascii() {
                return true;
            }
            i += 1;
        } else {
            i += 1;
        }
    }
    false
}

#[test]
fn non_ascii_counts_only_in_code() {
    for text in ["\"π\";", "'é';", "x; // ± 1", "/* /* 日本 */ é */ 1", "$\"; \"é\""] {
        assert!(!non_ascii_in_code(text), "{text}");
    }
    for text in ["z = ±1", "これは", "x = 1\u{a0}+ 2", "$é", "$\\é", "\"a\" ++ é"] {
        assert!(non_ascii_in_code(text), "{text}");
    }
}

/// Every .scd file under `dir`, by path relative to it, with its text.
fn texts(dir: &Path) -> BTreeMap<PathBuf, String> {
    glob::glob(&format!("{}/**/*.scd", dir.display()))
        .unwrap()
        .map(|entry| {
            let path = entry.unwrap();
            let text = fs::read_to_string(&path).unwrap();
            (path.strip_prefix(dir).unwrap().to_path_buf(), text)
        })
        .collect()
}

#[test]
#[ignore = "checks the corpus against the help; needs sclang, python3 and the help sources"]
fn corpus_design() {
    if !sclang_installed() {
        eprintln!("Skipping corpus_design: sclang is not installed");
        return;
    }
    let root = manifest_dir();
    let work = fresh_dir(&root.join("target/judge/design"));

    let candidates = work.join("candidates");
    let cut = Command::new("python3")
        .arg("-B")
        .arg("extract_help_from_docs.py")
        .arg("--candidates")
        .arg(&candidates)
        .current_dir(&root)
        .output();
    let cut = match cut {
        Ok(out) if out.status.success() => out,
        Ok(out) => panic!(
            "extract_help_from_docs.py --candidates failed:\n{}",
            String::from_utf8_lossy(&out.stderr)
        ),
        Err(e) => {
            eprintln!("Skipping corpus_design: cannot run python3 ({e})");
            return;
        }
    };
    eprint!("{}", String::from_utf8_lossy(&cut.stdout));

    // What the corpus should be: every form sclang accepts, less those with
    // characters outside ASCII in their code.
    let verdicts = judge(&candidates, &fresh_dir(&work.join("judge")));
    let mut candidate_texts = texts(&candidates);
    let mut non_ascii = 0;
    let expected: BTreeMap<PathBuf, String> = verdicts
        .iter()
        .filter(|(_, verdict)| matches!(verdict, Verdict::Accepted { .. }))
        .filter_map(|(path, _)| {
            let text = candidate_texts.remove(path).unwrap();
            let body = text.split_once('\n').map_or("", |(_, body)| body);
            if non_ascii_in_code(body) {
                non_ascii += 1;
                None
            } else {
                Some((path.clone(), text))
            }
        })
        .collect();
    let corpus = texts(&root.join("tests/sc_help"));

    let missing: String = expected
        .iter()
        .filter(|(path, text)| corpus.get(*path) != Some(text))
        .map(|(path, _)| format!("{}\n", path.display()))
        .collect();
    let extra: String = corpus
        .iter()
        .filter(|(path, text)| expected.get(*path) != Some(text))
        .map(|(path, _)| format!("{}\n", path.display()))
        .collect();
    fs::write(work.join("missing-from-corpus.txt"), &missing).unwrap();
    fs::write(work.join("not-to-be-in-corpus.txt"), &extra).unwrap();

    eprintln!("\n=== The corpus, by sclang ===");
    eprintln!("Candidates: {}", tally(&verdicts));
    eprintln!("Accepted, but with characters outside ASCII in code: {non_ascii}");
    eprintln!("Corpus: {} files, {} expected", corpus.len(), expected.len());
    assert!(
        missing.is_empty() && extra.is_empty(),
        "tests/sc_help is not what sclang makes of the help: {} accepted forms are \
         missing or differ ({}), {} files should not be there or differ ({}). \
         Regenerate it with `python3 extract_help_from_docs.py`.",
        missing.lines().count(),
        work.join("missing-from-corpus.txt").display(),
        extra.lines().count(),
        work.join("not-to-be-in-corpus.txt").display(),
    );
}
