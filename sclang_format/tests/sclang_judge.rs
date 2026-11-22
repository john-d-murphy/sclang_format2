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

use std::collections::{BTreeMap, BTreeSet};
use std::fs;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

/// Corpus files whose formatted text sclang compiles to something else, or
/// refuses. Each is a formatter bug or a grammar gap. The test tolerates
/// exactly these; one that stops differing must be removed. To list them
/// afresh, run this test and read `target/judge/meaning/differences.txt`,
/// which gives each differing file with both compilations or sclang's error:
///
///     cargo test --test sclang_judge formatting_keeps_meaning -- --test-threads=8
const KNOWN_MEANING_CHANGES: &[&str] = &[
    // Grammar gap: sclang reads any run of operator characters as one binary
    // operator; the grammar knows a fixed set and reads `<--`, `--`, `--->`,
    // `<!` or `<<*` as two, which spaces_around_binary_ops then parts:
    // `a <-- b` becomes `a < -- b`, which sclang refuses.
    "tests/sc_help/Classes/NodeProxy_2d.scd",
    "tests/sc_help/Classes/Set_8d.scd",
    "tests/sc_help/Guides/Order-of-execution_1.scd",
    "tests/sc_help/Guides/Order-of-execution_2.scd",
    "tests/sc_help/Other/JITLibChanges3.7_2_553.scd",
    "tests/sc_help/Overviews/Operators_18.scd",
    "tests/sc_help/Overviews/SymbolicNotations_18c.scd",
    "tests/sc_help/Overviews/SymbolicNotations_4.scd",
    "tests/sc_help/Overviews/SymbolicNotations_5i.scd",
    "tests/sc_help/Overviews/SymbolicNotations_9c.scd",
    // spaces_around_colons drops the space before an event key's colon, and
    // `(a : 10)` keys the event by the value of the variable `a`, where
    // `(a: 10)` keys it by the symbol `\a`.
    "tests/sc_help/Classes/Event_11c.scd",
    "tests/sc_help/Classes/Event_11e.scd",
];

fn manifest_dir() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
}

/// A fresh directory for one test's files, under target/judge/.
fn fresh_dir(path: &Path) -> PathBuf {
    let _ = fs::remove_dir_all(path);
    fs::create_dir_all(path).unwrap();
    path.to_path_buf()
}

fn sclang_installed() -> bool {
    Command::new("sclang")
        .arg("-v")
        .output()
        .is_ok_and(|out| out.status.success())
}

/// What sclang posted while compiling one file: the compiled function
/// written out, when it compiled, and the first line of each error.
struct Compiled {
    dump: Option<String>,
    errors: Vec<String>,
}

/// Compiles every .scd file under `dir` in one sclang run, headless, keyed by
/// path relative to `dir`. sclang's own files go under `work`.
fn compile_all(dir: &Path, work: &Path) -> BTreeMap<PathBuf, Compiled> {
    let xdg = work.join("xdg");
    fs::create_dir_all(&xdg).unwrap();
    let out = Command::new("timeout")
        .arg("300")
        .arg("sclang")
        .arg(manifest_dir().join("tests/judge.scd"))
        .arg(dir)
        .env("XDG_DATA_HOME", &xdg)
        .env("QT_QPA_PLATFORM", "offscreen")
        .current_dir(work)
        .stdin(Stdio::null())
        .output()
        .expect("run sclang");
    let stdout = String::from_utf8_lossy(&out.stdout);

    let mut files = BTreeMap::new();
    let mut current: Option<(PathBuf, Compiled)> = None;
    let mut done = false;
    for line in stdout.lines() {
        if let Some(path) = line.strip_prefix("@@judge file ") {
            let path = Path::new(path).strip_prefix(dir).unwrap().to_path_buf();
            current = Some((
                path,
                Compiled {
                    dump: None,
                    errors: Vec::new(),
                },
            ));
        } else if let Some(dump) = line.strip_prefix("@@judge accepted ") {
            let (path, mut compiled) = current.take().unwrap();
            compiled.dump = Some(dump.to_string());
            files.insert(path, compiled);
        } else if line == "@@judge refused" {
            let (path, compiled) = current.take().unwrap();
            files.insert(path, compiled);
        } else if line == "@@judge done" {
            done = true;
        } else if let (Some(error), Some((_, compiled))) =
            (line.strip_prefix("ERROR: "), current.as_mut())
        {
            compiled.errors.push(error.to_string());
        }
    }
    let said: Vec<&str> = stdout.lines().collect();
    assert!(
        done,
        "sclang did not finish judging {} ({}); the end of what it said:\n{}\n{}",
        dir.display(),
        out.status,
        said[said.len().saturating_sub(30)..].join("\n"),
        String::from_utf8_lossy(&out.stderr)
    );
    files
}

#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Debug)]
enum Reason {
    SyntaxError,
    UnknownClass,
    UndeclaredName,
    Other,
}

impl std::fmt::Display for Reason {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(match self {
            Self::SyntaxError => "syntax error",
            Self::UnknownClass => "unknown class",
            Self::UndeclaredName => "undeclared name",
            Self::Other => "other",
        })
    }
}

fn undeclared_names(errors: &[String]) -> Vec<String> {
    errors
        .iter()
        .filter_map(|e| e.strip_prefix("Variable '")?.strip_suffix("' not defined."))
        .map(String::from)
        .collect::<BTreeSet<_>>()
        .into_iter()
        .collect()
}

/// Why sclang refused a file. A syntax error stops sclang before it looks up
/// names, so it comes first; an unknown class comes before an undeclared name
/// because declaring the names could not help it.
fn reason(errors: &[String]) -> Reason {
    let any = |s: &str| errors.iter().any(|e| e.contains(s));
    if any("syntax error") || any("Parse error") {
        Reason::SyntaxError
    } else if any("Class not defined") {
        Reason::UnknownClass
    } else if !undeclared_names(errors).is_empty() {
        Reason::UndeclaredName
    } else {
        Reason::Other
    }
}

enum Verdict {
    /// Compiled, as it stands or with `declared` declared in front.
    Accepted {
        dump: String,
        declared: Vec<String>,
    },
    Refused {
        reason: Reason,
        error: String,
    },
}

/// The text with `names` declared in front, as its context would have done.
fn declare(names: &[String], text: &str) -> String {
    format!("var {};\n{text}", names.join(", "))
}

/// sclang's verdict on every .scd file under `dir`. A file refused only for
/// undeclared names is compiled once more with those names declared, so that
/// a fragment is not thrown out for a name its context would have supplied.
/// The verdicts are written to `work`/verdicts.txt.
fn judge(dir: &Path, work: &Path) -> BTreeMap<PathBuf, Verdict> {
    let mut verdicts = BTreeMap::new();
    let mut retried = BTreeMap::new();
    let retry_dir = fresh_dir(&work.join("declared"));
    for (path, compiled) in compile_all(dir, work) {
        let verdict = match (compiled.dump, reason(&compiled.errors)) {
            (Some(dump), _) => Verdict::Accepted {
                dump,
                declared: Vec::new(),
            },
            (None, Reason::UndeclaredName) => {
                let names = undeclared_names(&compiled.errors);
                let text = fs::read_to_string(dir.join(&path)).unwrap();
                let retry = retry_dir.join(&path);
                fs::create_dir_all(retry.parent().unwrap()).unwrap();
                fs::write(retry, declare(&names, &text)).unwrap();
                retried.insert(path, names);
                continue;
            }
            (None, reason) => Verdict::Refused {
                reason,
                error: compiled.errors.first().cloned().unwrap_or_default(),
            },
        };
        verdicts.insert(path, verdict);
    }
    if !retried.is_empty() {
        let mut second = compile_all(&retry_dir, work);
        for (path, declared) in retried {
            let compiled = second.remove(&path).unwrap();
            let verdict = match compiled.dump {
                Some(dump) => Verdict::Accepted { dump, declared },
                None => Verdict::Refused {
                    reason: reason(&compiled.errors),
                    error: compiled.errors.first().cloned().unwrap_or_default(),
                },
            };
            verdicts.insert(path, verdict);
        }
    }

    let lines: String = verdicts
        .iter()
        .map(|(path, verdict)| match verdict {
            Verdict::Accepted { declared, .. } if declared.is_empty() => {
                format!("{}\taccepted\n", path.display())
            }
            Verdict::Accepted { declared, .. } => {
                format!(
                    "{}\taccepted with var {}\n",
                    path.display(),
                    declared.join(", ")
                )
            }
            Verdict::Refused { reason, error } => {
                format!("{}\trefused: {reason}\t{error}\n", path.display())
            }
        })
        .collect();
    fs::write(work.join("verdicts.txt"), lines).unwrap();
    verdicts
}

/// `f` over `items` on every core: formatting the corpus in a test build
/// takes a minute and a half on one.
fn par_map<T: Sync, R: Send>(items: &[T], f: impl Fn(&T) -> R + Sync) -> Vec<R> {
    let cores = std::thread::available_parallelism().map_or(1, |n| n.get());
    let chunk = items.len().div_ceil(cores).max(1);
    std::thread::scope(|scope| {
        let workers: Vec<_> = items
            .chunks(chunk)
            .map(|part| scope.spawn(|| part.iter().map(&f).collect::<Vec<_>>()))
            .collect();
        workers
            .into_iter()
            .flat_map(|w| w.join().unwrap())
            .collect()
    })
}

/// The counts a run of `judge` comes to, one line.
fn tally(verdicts: &BTreeMap<PathBuf, Verdict>) -> String {
    let mut counts: BTreeMap<String, usize> = BTreeMap::new();
    for verdict in verdicts.values() {
        let key = match verdict {
            Verdict::Accepted { declared, .. } if declared.is_empty() => {
                "accepted as it stands".into()
            }
            Verdict::Accepted { .. } => "accepted with names declared".into(),
            Verdict::Refused { reason, .. } => format!("refused, {reason}"),
        };
        *counts.entry(key).or_default() += 1;
    }
    let parts: Vec<String> = counts.iter().map(|(k, n)| format!("{k}: {n}")).collect();
    format!("{} files; {}", verdicts.len(), parts.join("; "))
}

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
