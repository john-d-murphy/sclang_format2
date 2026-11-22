//! sclang, SuperCollider's own compiler, as the judge of what is SuperCollider.
//!
//! `tests/judge.scd` compiles files (it never runs them) and posts what sclang
//! made of each; tests/common/judge.rs drives it. The tests need sclang and
//! skip, saying so, when it is not installed.
//!
//! - `formatting_keeps_meaning` runs with plain `cargo test`: every corpus
//!   file sclang accepts must, once formatted, be accepted again and compile
//!   to the same thing.
//! - `test_suite_scripts_keep_their_meaning` requires the same of the
//!   scripts of SuperCollider's own test suite, and skips when its source
//!   is not there.
//! - `class_library_keeps_its_meaning` formats the class library as it is
//!   installed and requires sclang to compile the formatted library to the
//!   same classes and methods.
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
    Verdict, compile_all, compile_classes, declare, fresh_dir, judge, manifest_dir, par_map,
    sclang_installed, tally,
};
use std::collections::BTreeMap;
use std::collections::BTreeSet;
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

/// What formatting does to every .scd file under a directory, as sclang
/// sees it. Paths are given from the directory.
struct Formatted {
    verdicts: BTreeMap<PathBuf, Verdict>,
    /// How many files sclang compiled both as they stand and formatted.
    compared: usize,
    /// Files that compile to something else once formatted, or no longer
    /// compile, each with both compilations or sclang's error.
    differing: BTreeMap<PathBuf, String>,
    /// Files sclang accepts and the formatter refuses.
    unformatted: Vec<PathBuf>,
    /// Files sclang refuses as they stand and accepts once formatted.
    revived: Vec<PathBuf>,
}

/// Has sclang judge every .scd file under `corpus`, formats each, and has
/// sclang judge what came out. sclang's own files go under `work`.
fn format_and_judge(corpus: &Path, work: &Path) -> Formatted {
    let verdicts = judge(corpus, work);

    // Each file formatted, with the names sclang needed declared in front.
    let formatted_dir = fresh_dir(&work.join("formatted"));
    let paths: Vec<&PathBuf> = verdicts.keys().collect();
    let written = par_map(&paths, |path| {
        let text = fs::read_to_string(corpus.join(path)).unwrap();
        let formatted = sclang_format::format_source(&text, "all").ok()?;
        let out = formatted_dir.join(path);
        fs::create_dir_all(out.parent().unwrap()).unwrap();
        let formatted = match &verdicts[*path] {
            Verdict::Accepted { declared, .. } if !declared.is_empty() => {
                declare(declared, &formatted)
            }
            _ => formatted,
        };
        fs::write(out, formatted).unwrap();
        Some(())
    });
    let mut compiled = compile_all(&formatted_dir, work);

    let mut result = Formatted {
        verdicts: BTreeMap::new(),
        compared: 0,
        differing: BTreeMap::new(),
        unformatted: Vec::new(),
        revived: Vec::new(),
    };
    for (path, written) in paths.into_iter().zip(written) {
        let after = written.map(|()| compiled.remove(path).unwrap());
        match (&verdicts[path], after) {
            (Verdict::Accepted { .. }, None) => result.unformatted.push(path.clone()),
            (Verdict::Accepted { dump, .. }, Some(after)) => {
                result.compared += 1;
                match after.dump {
                    Some(formatted) if formatted == *dump => {}
                    Some(formatted) => {
                        let how = format!("original:  {dump}\nformatted: {formatted}");
                        result.differing.insert(path.clone(), how);
                    }
                    None => {
                        let how = format!("refused once formatted: {}", after.errors.join(" | "));
                        result.differing.insert(path.clone(), how);
                    }
                }
            }
            (Verdict::Refused { .. }, Some(after)) if after.dump.is_some() => {
                result.revived.push(path.clone());
            }
            (Verdict::Refused { .. }, _) => {}
        }
    }
    result.verdicts = verdicts;
    result
}

#[test]
fn formatting_keeps_meaning() {
    if !sclang_installed() {
        eprintln!("Skipping formatting_keeps_meaning: sclang is not installed");
        return;
    }
    let corpus = manifest_dir().join("tests/sc_help");
    let work = fresh_dir(&manifest_dir().join("target/judge/meaning"));
    // A file the formatter refuses is the corpus test's business.
    let formatted = format_and_judge(&corpus, &work);

    let differing: BTreeMap<String, &String> = formatted
        .differing
        .iter()
        .map(|(path, how)| (format!("tests/sc_help/{}", path.display()), how))
        .collect();
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
    eprintln!("Corpus: {}", tally(&formatted.verdicts));
    eprintln!("Compared: {}", formatted.compared);
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

/// The scripts of SuperCollider's own test suite. Ten are code, and the
/// formatter must take each of those and keep what it means. Two sclang
/// refuses: a log of failures kept under the name of a script
/// (classlibrary/current-failures.scd), and blocks written to be run one at
/// a time (sclang/lpc/test_script.scd). None is there to be refused, so the
/// rule for what sclang refuses is the plain one: the formatter must not
/// make of it something sclang accepts. It may refuse it too.
#[test]
fn test_suite_scripts_keep_their_meaning() {
    if !sclang_installed() {
        eprintln!("Skipping test_suite_scripts_keep_their_meaning: sclang is not installed");
        return;
    }
    let scripts = manifest_dir().join("target/sc-source/testsuite");
    if !scripts.is_dir() {
        eprintln!(
            "Skipping test_suite_scripts_keep_their_meaning: no SuperCollider source at {} \
             (the top of tests/class_library.rs says how to fetch it)",
            scripts.display()
        );
        return;
    }
    let work = fresh_dir(&manifest_dir().join("target/judge/test_suite"));
    let formatted = format_and_judge(&scripts, &work);

    eprintln!("\n=== The test suite's scripts ===");
    eprintln!("Scripts: {}", tally(&formatted.verdicts));
    eprintln!("Compared: {}", formatted.compared);
    assert!(
        formatted.differing.is_empty()
            && formatted.unformatted.is_empty()
            && formatted.revived.is_empty(),
        "Mean something else once formatted: {:?}\n\
         sclang accepts them and the formatter refuses them: {:?}\n\
         sclang refuses them, and accepts them once formatted: {:?}",
        formatted.differing,
        formatted.unformatted,
        formatted.revived
    );
}

/// The class library as it is installed, and the same library formatted,
/// each compiled by sclang in place of its own: the two must hold the same
/// classes, with the same variables and constants, and the same methods,
/// each compiled to the same code. The help corpus and the forms of
/// tests/lang11d are interpreted code; this is what says that formatting a
/// class file keeps its meaning, on every class file SuperCollider has.
#[test]
fn class_library_keeps_its_meaning() {
    let library = Path::new("/usr/share/SuperCollider/SCClassLibrary");
    if !sclang_installed() || !library.is_dir() {
        eprintln!(
            "Skipping class_library_keeps_its_meaning: needs sclang and its class library at {}",
            library.display()
        );
        return;
    }
    let work = fresh_dir(&manifest_dir().join("target/judge/class_library"));

    // The library formatted, file for file. A file the formatter refuses
    // is tests/class_library.rs's business, and is copied as it stands.
    let formatted_dir = work.join("formatted");
    let files: Vec<PathBuf> = glob::glob(&format!("{}/**/*.sc", library.display()))
        .unwrap()
        .map(Result::unwrap)
        .collect();
    par_map(&files, |path| {
        let text = fs::read_to_string(path).unwrap();
        let formatted = sclang_format::format_source(&text, "all").unwrap_or(text);
        let out = formatted_dir.join(path.strip_prefix(library).unwrap());
        fs::create_dir_all(out.parent().unwrap()).unwrap();
        fs::write(out, formatted).unwrap();
    });

    let compile = |dir: &Path, name: &str| -> BTreeSet<String> {
        compile_classes(dir, &fresh_dir(&work.join(name)), false)
            .unwrap_or_else(|said| {
                panic!("sclang did not compile {}; it said:\n{said}", dir.display())
            })
            .into_iter()
            .collect()
    };
    let original = compile(library, "original-work");
    let formatted = compile(&formatted_dir, "formatted-work");

    // A line is `class <name> <file> ...` or `method <class>:<name> <file> ...`.
    let name = |line: &String| line.split(' ').take(3).collect::<Vec<_>>().join(" ");
    let changed: BTreeSet<String> = original
        .symmetric_difference(&formatted)
        .map(name)
        .collect();
    eprintln!(
        "class library: {} files, {} classes and methods, {} changed by formatting",
        files.len(),
        original.len(),
        changed.len()
    );
    assert!(
        changed.is_empty(),
        "{} classes and methods of the class library mean something else once formatted:\n{}",
        changed.len(),
        changed
            .iter()
            .take(40)
            .map(|c| format!("  {c}\n"))
            .collect::<String>()
    );
}

/// Whether `text` holds a character outside ASCII anywhere but in a string,
/// a quoted symbol or a comment. sclang's lexer skips such bytes, so it
/// accepts prose in Japanese or `z = ±1`; the corpus leaves those forms out.
/// The same reading as `non_ascii_in_code` in extract_help_from_docs.py.
fn non_ascii_in_code(text: &str) -> bool {
    let chars: Vec<char> = text.chars().collect();
    let at = |i: usize, s: &str| {
        s.chars()
            .enumerate()
            .all(|(k, c)| chars.get(i + k) == Some(&c))
    };
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
    for text in [
        "\"π\";",
        "'é';",
        "x; // ± 1",
        "/* /* 日本 */ é */ 1",
        "$\"; \"é\"",
    ] {
        assert!(!non_ascii_in_code(text), "{text}");
    }
    for text in [
        "z = ±1",
        "これは",
        "x = 1\u{a0}+ 2",
        "$é",
        "$\\é",
        "\"a\" ++ é",
    ] {
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
    eprintln!(
        "Corpus: {} files, {} expected",
        corpus.len(),
        expected.len()
    );
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
