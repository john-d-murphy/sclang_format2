//! sclang, SuperCollider's own compiler, driven for the tests that have it
//! judge: `tests/judge.scd` compiles files (it never runs them) and posts
//! what sclang made of each, and this reads what it posted.

use std::collections::{BTreeMap, BTreeSet};
use std::fs;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

pub fn manifest_dir() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
}

/// A fresh directory for one test's files, under target/judge/.
pub fn fresh_dir(path: &Path) -> PathBuf {
    let _ = fs::remove_dir_all(path);
    fs::create_dir_all(path).unwrap();
    path.to_path_buf()
}

pub fn sclang_installed() -> bool {
    Command::new("sclang")
        .arg("-v")
        .output()
        .is_ok_and(|out| out.status.success())
}

/// What sclang posted while compiling one file: the compiled function
/// written out, when it compiled, and the first line of each error.
pub struct Compiled {
    pub dump: Option<String>,
    pub errors: Vec<String>,
}

/// Compiles every .scd file under `dir` in one sclang run, headless, keyed by
/// path relative to `dir`. sclang's own files go under `work`.
pub fn compile_all(dir: &Path, work: &Path) -> BTreeMap<PathBuf, Compiled> {
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

/// What sclang's class library holds from the class files under `dir`: one
/// line for each class and each method, as `tests/judge.scd` posts them,
/// less the `@@judge` that opens the line, so `class <name> <file> ...` or
/// `method <class>:<name> <file> ...`, the file given from `dir`. sclang
/// compiles class files only as it starts, with `dir` as an include path; a
/// file it refuses leaves it without a library, and then what it said is
/// the error.
pub fn compile_classes(dir: &Path, work: &Path) -> Result<Vec<String>, String> {
    let xdg = work.join("xdg");
    fs::create_dir_all(&xdg).unwrap();
    let configuration = work.join("sclang_conf.yaml");
    fs::write(
        &configuration,
        format!(
            "includePaths:\n    - {}\nexcludePaths: []\npostInlineWarnings: false\n",
            dir.display()
        ),
    )
    .unwrap();
    let out = Command::new("timeout")
        .arg("300")
        .arg("sclang")
        .arg("-l")
        .arg(&configuration)
        .arg(manifest_dir().join("tests/judge.scd"))
        .arg(dir)
        .arg("classes")
        .env("XDG_DATA_HOME", &xdg)
        .env("QT_QPA_PLATFORM", "offscreen")
        .current_dir(work)
        .stdin(Stdio::null())
        .output()
        .expect("run sclang");
    let stdout = String::from_utf8_lossy(&out.stdout);
    if !stdout.lines().any(|line| line == "@@judge done") {
        let said: Vec<&str> = stdout.lines().collect();
        return Err(said[said.len().saturating_sub(40)..].join("\n"));
    }
    Ok(stdout
        .lines()
        .filter_map(|line| line.strip_prefix("@@judge "))
        .filter(|line| line.starts_with("class ") || line.starts_with("method "))
        .map(String::from)
        .collect())
}

#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Debug)]
pub enum Reason {
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

pub fn undeclared_names(errors: &[String]) -> Vec<String> {
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
pub fn reason(errors: &[String]) -> Reason {
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

pub enum Verdict {
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
pub fn declare(names: &[String], text: &str) -> String {
    format!("var {};\n{text}", names.join(", "))
}

/// sclang's verdict on every .scd file under `dir`. A file refused only for
/// undeclared names is compiled once more with those names declared, so that
/// a fragment is not thrown out for a name its context would have supplied.
/// The verdicts are written to `work`/verdicts.txt.
pub fn judge(dir: &Path, work: &Path) -> BTreeMap<PathBuf, Verdict> {
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

/// How many threads the test run was told to use: `--test-threads` as the
/// test binary was given it, or RUST_TEST_THREADS, and every core when
/// neither is set. This is libtest's own reading.
pub fn test_threads() -> usize {
    let args: Vec<String> = std::env::args().collect();
    let given = args.iter().enumerate().find_map(|(i, arg)| {
        arg.strip_prefix("--test-threads=")
            .or_else(|| (arg == "--test-threads").then(|| args.get(i + 1).map_or("", String::as_str)))
    });
    given
        .map(String::from)
        .or_else(|| std::env::var("RUST_TEST_THREADS").ok())
        .and_then(|n| n.parse().ok())
        .filter(|n| *n > 0)
        .unwrap_or_else(|| std::thread::available_parallelism().map_or(1, |n| n.get()))
}

/// `f` over `items` on as many threads as the test run may use: formatting
/// the corpus in a test build takes a minute and a half on one.
pub fn par_map<T: Sync, R: Send>(items: &[T], f: impl Fn(&T) -> R + Sync) -> Vec<R> {
    let chunk = items.len().div_ceil(test_threads()).max(1);
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
pub fn tally(verdicts: &BTreeMap<PathBuf, Verdict>) -> String {
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
