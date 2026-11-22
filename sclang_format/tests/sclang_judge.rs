//! sclang, SuperCollider's own compiler, as the judge of what is SuperCollider.
//!
//! `tests/judge.scd` compiles files (it never runs them) and posts what sclang
//! made of each; this file drives it. Both tests need sclang and skip, saying
//! so, when it is not installed.
//!
//! - `formatting_keeps_meaning` runs with plain `cargo test`: every corpus
//!   file sclang accepts must, once formatted, be accepted again and compile
//!   to the same thing.
//! - `corpus_design` lists rather than checks, and needs python3 and the
//!   SuperCollider help sources as well, so it runs only when asked for:
//!
//!       cargo test --test sclang_judge -- --ignored --nocapture
//!
//!   It cuts every form from the help with `extract_help_from_docs.py
//!   --candidates`, and writes under
//!   `target/judge/` the corpus files sclang refuses as syntax errors and the
//!   valid forms the corpus does not have.

use std::collections::{BTreeMap, BTreeSet};
use std::fs;
use std::panic::catch_unwind;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

/// Corpus files whose formatted text sclang compiles to something else, or
/// refuses. Each is a formatter bug or a difference not yet explained. The
/// test tolerates exactly these; one that stops differing must be removed.
const KNOWN_MEANING_CHANGES: &[&str] = &[
    // PipeParamDefaultParens wraps a literal default in parentheses:
    // `{ |a = #[1, 2]| a }` becomes `{ |a = (#[1, 2])| a }`. A parenthesized
    // default is an expression, which sclang compiles to a test at the top of
    // the function that puts the default in when the argument is nil, so
    // `.value(nil)` returns [1, 2] where it returned nil.
    "tests/sc_help/Classes/Event_15.scd",
    "tests/sc_help/Classes/NdefParamGui_0p.scd",
    "tests/sc_help/Classes/NodeProxy_17_35.scd",
    "tests/sc_help/Classes/NodeProxy_17_37.scd",
    "tests/sc_help/Classes/NodeProxy_17_38.scd",
    "tests/sc_help/Classes/Node_4b.scd",
    "tests/sc_help/Classes/Node_6g.scd",
    "tests/sc_help/Classes/Synth_1e.scd",
    "tests/sc_help/Classes/Synth_6a.scd",
    "tests/sc_help/Guides/Multichannel-Expansion_15a.scd",
    "tests/sc_help/Guides/NodeMessaging_9.scd",
    "tests/sc_help/Guides/UserFAQ_23.scd",
    "tests/sc_help/Guides/UserFAQ_26.scd",
    "tests/sc_help/Reference/Functions_5c.scd",
    "tests/sc_help/Tutorials/JITLib/jitlib_basic_concepts_03_18b.scd",
    "tests/sc_help/Tutorials/JITLib/proxyspace_examples_7e.scd",
    // A binary operator split in two, which sclang refuses:
    // `a <-- b` becomes `a < -- b`, and `a -- b` becomes `a - - b`.
    "tests/sc_help/Classes/NodeProxy_2d.scd",
    "tests/sc_help/Classes/Set_8d.scd",
    "tests/sc_help/Overviews/SymbolicNotations_4a.scd",
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

/// What must survive formatting, counted. A copy of `essence` in
/// tests/keeps_tokens.rs, which tests/common does not yet offer.
fn essence(src: &str) -> BTreeMap<String, usize> {
    let mut counts = BTreeMap::new();
    let mut word = String::new();
    for c in src.chars().chain(std::iter::once(' ')) {
        if c.is_alphanumeric() || c == '_' {
            word.push(c);
            continue;
        }
        if !word.is_empty() && word != "arg" {
            *counts.entry(std::mem::take(&mut word)).or_insert(0) += 1;
        }
        word.clear();
        if !c.is_whitespace() && !"(),;|".contains(c) {
            *counts.entry(c.to_string()).or_insert(0) += 1;
        }
    }
    counts
}

/// Whether the formatter can format `text` today: it parses, a second pass
/// changes nothing, and every token is kept.
fn formatter_status(text: &str) -> &'static str {
    let format = |s: &str| catch_unwind(|| sclang_format::format_source(s, "all"));
    match format(text) {
        Err(_) => "formatter panics",
        Ok(Err(_)) => "formatter refuses",
        Ok(Ok(once)) => match format(&once) {
            Err(_) | Ok(Err(_)) => "second pass fails",
            Ok(Ok(twice)) if twice != once => "not idempotent",
            Ok(Ok(_)) if essence(text) != essence(&once) => "loses tokens",
            Ok(Ok(_)) => "formats",
        },
    }
}

/// A form's text with the extraction header and every blank dropped, so that
/// a form is found in the corpus whatever its file is called there and however
/// it is spaced: the help has been respaced since the corpus was cut from it
/// (`|x=0|` is now `|x = 0|`), and the corpus mended by hand.
fn form_text(text: &str) -> String {
    let body = match text.split_once('\n') {
        Some((first, rest)) if first.starts_with("// Source:") => rest,
        _ => text,
    };
    body.split_whitespace().collect()
}

#[test]
#[ignore = "lists what the corpus should become; needs sclang, python3 and the help sources"]
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

    let corpus = root.join("tests/sc_help");
    let candidate_verdicts = judge(&candidates, &fresh_dir(&work.join("judge-candidates")));
    let corpus_verdicts = judge(&corpus, &fresh_dir(&work.join("judge-corpus")));

    // In the corpus, refused by sclang as a syntax error.
    let not_code: String = corpus_verdicts
        .iter()
        .filter_map(|(path, verdict)| match verdict {
            Verdict::Refused {
                reason: Reason::SyntaxError,
                error,
            } => Some(format!("tests/sc_help/{}\t{error}\n", path.display())),
            _ => None,
        })
        .collect();
    fs::write(work.join("corpus-syntax-errors.txt"), &not_code).unwrap();

    // Accepted by sclang, not in the corpus, with what the formatter makes of it.
    let in_corpus: BTreeSet<String> = corpus_verdicts
        .keys()
        .map(|path| form_text(&fs::read_to_string(corpus.join(path)).unwrap()))
        .collect();
    let not_in_corpus: Vec<(&PathBuf, String, &Vec<String>)> = candidate_verdicts
        .iter()
        .filter_map(|(path, verdict)| match verdict {
            Verdict::Accepted { declared, .. } => {
                let text = fs::read_to_string(candidates.join(path)).unwrap();
                (!in_corpus.contains(&form_text(&text))).then_some((path, text, declared))
            }
            Verdict::Refused { .. } => None,
        })
        .collect();
    let mut statuses: BTreeMap<&str, usize> = BTreeMap::new();
    let mut missing: Vec<String> = not_in_corpus
        .iter()
        .zip(par_map(&not_in_corpus, |(_, text, _)| {
            formatter_status(text)
        }))
        .map(|((path, _, declared), status)| {
            *statuses.entry(status).or_default() += 1;
            let route = if declared.is_empty() {
                "as it stands".to_string()
            } else {
                format!("with var {}", declared.join(", "))
            };
            format!("{status}\t{}\t{route}\n", path.display())
        })
        .collect();
    missing.sort();
    fs::write(work.join("valid-not-in-corpus.txt"), missing.concat()).unwrap();

    eprintln!("\n=== The corpus, by sclang ===");
    eprintln!("Candidates: {}", tally(&candidate_verdicts));
    eprintln!("Corpus: {}", tally(&corpus_verdicts));
    eprintln!(
        "In the corpus, refused as a syntax error: {} ({})",
        not_code.lines().count(),
        work.join("corpus-syntax-errors.txt").display()
    );
    eprintln!(
        "Accepted by sclang, not in the corpus: {} ({})",
        missing.len(),
        work.join("valid-not-in-corpus.txt").display()
    );
    for (status, n) in &statuses {
        eprintln!("  {status}: {n}");
    }
}
