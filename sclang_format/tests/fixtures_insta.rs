use glob::glob;
use pretty_assertions::assert_eq;
use seq_macro::seq;
use std::fs::{File, create_dir_all};
use std::io::Write;
use std::path::{Path, PathBuf};
use std::process::{Command, ExitStatus, Stdio};

mod common;

// NOTE: seq_macro requires literal ranges like 0..16 (not a const),
// so SHARDS is used for runtime logic only. The macro range below must match.
const SHARDS: usize = 16;

/// Parse FIXTURE env var. Returns (fixture_filters, is_sc_help_filter)
/// If FIXTURE starts with "sc_help/", it's treated as a path pattern for sc_help files.
/// Otherwise, it's a fixture name under tests/fixtures/.
fn parse_fixture_filter() -> Option<Vec<String>> {
    let raw = std::env::var("FIXTURE").ok()?;
    let list = raw
        .split(',')
        .map(|s| s.trim())
        .filter(|s| !s.is_empty())
        .map(|s| s.to_string())
        .collect::<Vec<_>>();

    if list.is_empty() { None } else { Some(list) }
}

/// Check if FIXTURE is targeting sc_help files
fn is_sc_help_fixture() -> bool {
    std::env::var("FIXTURE")
        .map(|f| f.starts_with("sc_help/") || f.starts_with("sc_help\\"))
        .unwrap_or(false)
}

/// Get sc_help fixture patterns (if FIXTURE targets sc_help)
fn get_sc_help_fixture_patterns() -> Option<Vec<String>> {
    let raw = std::env::var("FIXTURE").ok()?;
    if !raw.starts_with("sc_help/") && !raw.starts_with("sc_help\\") {
        return None;
    }

    let list: Vec<String> = raw
        .split(',')
        .map(|s| s.trim().to_string())
        .filter(|s| !s.is_empty())
        .collect();

    if list.is_empty() { None } else { Some(list) }
}

fn fixture_name_from_input_path(input_path: &Path) -> String {
    // tests/fixtures/<fixture_name>/input.scd  -> "<fixture_name>"
    let rel = input_path.strip_prefix("tests/fixtures").unwrap();
    rel.parent().unwrap().to_string_lossy().replace('/', "__")
}

fn fixture_is_selected(fixture: &str, selected: &Option<Vec<String>>) -> bool {
    match selected {
        None => true,
        Some(list) => list.iter().any(|x| x == fixture),
    }
}

/// Check if an sc_help path matches the FIXTURE pattern
fn sc_help_path_matches(path: &Path, patterns: &[String]) -> bool {
    let path_str = path.to_string_lossy();
    patterns.iter().any(|pattern| {
        // Support both exact match and prefix match
        // FIXTURE=sc_help/Classes/SinOsc matches tests/sc_help/Classes/SinOsc_0.scd
        let normalized_pattern = pattern.replace('\\', "/");
        let normalized_path = path_str.replace('\\', "/");

        // Strip "tests/" prefix if present in pattern
        let pattern_clean = normalized_pattern
            .strip_prefix("tests/")
            .unwrap_or(&normalized_pattern);
        let path_clean = normalized_path
            .strip_prefix("tests/")
            .unwrap_or(&normalized_path);

        path_clean.starts_with(pattern_clean) || path_clean.contains(pattern_clean)
    })
}

#[test]
fn format_fixtures_to_snapshots() {
    // Skip if FIXTURE is targeting sc_help files
    if is_sc_help_fixture() {
        eprintln!("Skipping format_fixtures_to_snapshots - FIXTURE targets sc_help");
        return;
    }

    let selected = parse_fixture_filter();
    let mut ran_any = false;

    for entry in glob("tests/fixtures/**/input.scd").unwrap() {
        let input_path = entry.unwrap();
        let fixture = fixture_name_from_input_path(&input_path);

        // Deterministic: only run exact fixture-name matches when FIXTURE is set.
        if !fixture_is_selected(&fixture, &selected) {
            continue;
        }
        ran_any = true;

        let input = std::fs::read_to_string(&input_path).unwrap();
        let out = common::run_cli_on_str(&input).unwrap();

        let snapshot_test_name = format!("{fixture}__inline");
        insta::with_settings!({ snapshot_suffix => "out" }, {
            insta::assert_snapshot!(snapshot_test_name, out);
        });
    }

    // Fail fast if the user asked for a fixture and we didn't find it.
    if selected.is_some() && !ran_any {
        panic!(
            "FIXTURE was set, but no matching fixtures were found.\n\
             Expected an exact fixture directory name under tests/fixtures.\n\
             Example: FIXTURE=add_missing_commas\n\
             For sc_help files, use: FIXTURE=sc_help/Classes/SinOsc"
        );
    }
}

#[test]
fn formatter_is_idempotent() {
    // Skip if FIXTURE is targeting sc_help files
    if is_sc_help_fixture() {
        eprintln!("Skipping formatter_is_idempotent - FIXTURE targets sc_help");
        return;
    }

    let selected = parse_fixture_filter();
    let mut ran_any = false;

    for entry in glob("tests/fixtures/**/input.scd").unwrap() {
        let input_path = entry.unwrap();
        let fixture = fixture_name_from_input_path(&input_path);

        if !fixture_is_selected(&fixture, &selected) {
            continue;
        }
        ran_any = true;

        let input = std::fs::read_to_string(&input_path).unwrap();
        let once = common::run_cli_on_str(&input).unwrap();
        let twice = common::run_cli_on_str(&once).unwrap();
        assert_eq!(twice, once, "formatter must be idempotent for {}", fixture);
    }

    if selected.is_some() && !ran_any {
        panic!(
            "FIXTURE was set, but no matching fixtures were found.\n\
             Expected an exact fixture directory name under tests/fixtures."
        );
    }
}

/// Run specific sc_help files when FIXTURE=sc_help/... is set
#[test]
fn sc_help_fixture() {
    let patterns = match get_sc_help_fixture_patterns() {
        Some(p) => p,
        None => {
            eprintln!("Skipping sc_help_fixture - FIXTURE not targeting sc_help");
            return;
        }
    };

    let pattern = "tests/sc_help/**/*.scd";
    let mut paths: Vec<_> = glob(pattern).unwrap().map(|e| e.unwrap()).collect();
    paths.sort();

    let mut ran_any = false;
    let mut failures = Vec::new();

    for path in &paths {
        if !sc_help_path_matches(path, &patterns) {
            continue;
        }
        ran_any = true;

        let input = std::fs::read_to_string(path).unwrap();

        match run_cli_on_str_capture(&input) {
            Ok(output) => {
                // Create snapshot name from path: sc_help/Classes/Foo_0.scd -> sc_help__Classes__Foo_0
                let snapshot_name = path
                    .to_string_lossy()
                    .strip_prefix("tests/")
                    .unwrap_or(&path.to_string_lossy())
                    .replace('/', "__")
                    .replace(".scd", "");

                insta::with_settings!({ snapshot_suffix => "out" }, {
                    insta::assert_snapshot!(snapshot_name, output.clone());
                });

                // Check idempotency
                match run_cli_on_str_capture(&output) {
                    Ok(output2) => {
                        if output != output2 {
                            failures.push(format!("{}: not idempotent", path.display()));
                        }
                    }
                    Err(e) => {
                        failures.push(format!("{}: 2nd pass failed - {}", path.display(), e));
                    }
                }
            }
            Err(e) => {
                failures.push(format!("{}: {}", path.display(), e));
            }
        }
    }

    if !ran_any {
        panic!(
            "FIXTURE was set to sc_help pattern, but no matching files found.\n\
             Patterns: {:?}\n\
             Example: FIXTURE=sc_help/Classes/SinOsc",
            patterns
        );
    }

    if !failures.is_empty() {
        panic!("\n--- Failures ---\n{}", failures.join("\n"));
    }
}

/// Test that all SuperCollider help documentation examples format correctly.
/// These are extracted from /usr/share/SuperCollider/HelpSource/ using
/// extract_help_from_docs.py
///
/// Run with: cargo test sc_help_corpus_idempotent
/// Skip with: cargo test -- --skip sc_help_corpus_idempotent
#[test]
fn sc_help_corpus_idempotent() {
    // Skip if FIXTURE is set - user wants to run specific files only
    if std::env::var("FIXTURE").is_ok() {
        eprintln!("Skipping sc_help_corpus_idempotent because FIXTURE is set");
        return;
    }

    let pattern = "tests/sc_help/**/*.scd";
    let entries: Vec<_> = glob(pattern).unwrap().collect();

    if entries.is_empty() {
        eprintln!("No sc_help corpus files found. Run extract_help_from_docs.py first.");
        return;
    }

    let mut parse_failures = Vec::new();
    let mut idempotency_failures = Vec::new();
    let mut success_count = 0usize;

    for entry in entries {
        let path = entry.unwrap();
        let input = std::fs::read_to_string(&path).unwrap();

        let once = match common::run_cli_on_str(&input) {
            Ok(out) => out,
            Err(e) => {
                parse_failures.push(format!("{}: {}", path.display(), e));
                continue;
            }
        };

        let twice = match common::run_cli_on_str(&once) {
            Ok(out) => out,
            Err(e) => {
                parse_failures.push(format!("{} (2nd pass): {}", path.display(), e));
                continue;
            }
        };

        if once != twice {
            idempotency_failures.push(path.display().to_string());
        } else {
            success_count += 1;
        }
    }

    let total = success_count + parse_failures.len() + idempotency_failures.len();
    eprintln!("\n=== SC Help Corpus Results ===");
    eprintln!("Total: {}", total);
    eprintln!("Success: {}", success_count);
    eprintln!("Parse failures: {}", parse_failures.len());
    eprintln!("Idempotency failures: {}", idempotency_failures.len());

    if !parse_failures.is_empty() || !idempotency_failures.is_empty() {
        let mut msg = String::new();

        if !parse_failures.is_empty() {
            msg.push_str(&format!(
                "\n--- Parse Failures ({}) ---\n",
                parse_failures.len()
            ));
            for f in &parse_failures[..parse_failures.len().min(20)] {
                msg.push_str(&format!("  {}\n", f));
            }
            if parse_failures.len() > 100 {
                msg.push_str(&format!("  ... and {} more\n", parse_failures.len() - 100));
            }
        }

        if !idempotency_failures.is_empty() {
            msg.push_str(&format!(
                "\n--- Idempotency Failures ({}) ---\n",
                idempotency_failures.len()
            ));
            for f in &idempotency_failures[..idempotency_failures.len().min(20)] {
                msg.push_str(&format!("  {}\n", f));
            }
            if idempotency_failures.len() > 20 {
                msg.push_str(&format!(
                    "  ... and {} more\n",
                    idempotency_failures.len() - 20
                ));
            }
        }

        panic!("{}", msg);
    }
}

// ----------------------------
// Sharded SC help corpus runner
// ----------------------------

#[derive(Clone, Debug)]
struct ParseFailure {
    path: String,
    pass: u8,                // 1 or 2
    trigger: Option<String>, // Triggered by Rule: ...
    status: Option<String>,  // exit status
    msg: String,             // short one-line summary
}

#[derive(Debug)]
struct CliRunErr {
    status: ExitStatus,
    stderr: String,
    trigger_rule: Option<String>,
}

impl std::fmt::Display for CliRunErr {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        if let Some(r) = &self.trigger_rule {
            write!(f, "formatter non-zero ({}) trigger={}", self.status, r)
        } else {
            write!(f, "formatter non-zero ({})", self.status)
        }
    }
}
impl std::error::Error for CliRunErr {}

fn extract_trigger_rule(stderr: &str) -> Option<String> {
    stderr
        .lines()
        .find_map(|l| l.strip_prefix("Triggered by Rule:"))
        .map(|s| s.trim().to_string())
}

/// Produce a short, TSV-safe, one-line summary from stderr.
fn stderr_one_liner(stderr: &str) -> String {
    // Pick first non-empty line; fallback to "<empty stderr>"
    let line = stderr
        .lines()
        .map(|l| l.trim_end())
        .find(|l| !l.trim().is_empty())
        .unwrap_or("<empty stderr>");

    // Make it TSV-safe.
    line.replace('\t', " ").replace('\r', "")
}

fn shard_results_dir() -> PathBuf {
    PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("target")
        .join("sc_help_shards")
}

fn shard_results_path(shard_idx: usize) -> PathBuf {
    shard_results_dir().join(format!("shard_{shard_idx}.tsv"))
}

/// Like common::run_cli_on_str, but captures stderr and extracts Triggered-by line.
fn run_cli_on_str_capture(input: &str) -> Result<String, CliRunErr> {
    let mut cmd = Command::new(assert_cmd::cargo::cargo_bin!("sclang_format"));
    cmd.stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped());

    let mut child = cmd.spawn().expect("spawn formatter");
    child
        .stdin
        .as_mut()
        .expect("child stdin")
        .write_all(input.as_bytes())
        .expect("write stdin");
    let out = child.wait_with_output().expect("wait_with_output");

    let stdout = String::from_utf8_lossy(&out.stdout).to_string();
    let stderr = String::from_utf8_lossy(&out.stderr).to_string();

    if out.status.success() {
        Ok(stdout)
    } else {
        Err(CliRunErr {
            status: out.status,
            trigger_rule: extract_trigger_rule(&stderr),
            stderr,
        })
    }
}

fn write_shard_tsv(
    shard_idx: usize,
    shards: usize,
    success: usize,
    parse_failures: &[ParseFailure],
    idempotency_failures: &[String],
) {
    let dir = shard_results_dir();
    create_dir_all(&dir).unwrap();

    let path = shard_results_path(shard_idx);
    let mut f = File::create(&path).unwrap();

    // SUMMARY  shard  shards  success  parse_failures  idempotency_failures
    writeln!(
        f,
        "SUMMARY\t{}\t{}\t{}\t{}\t{}",
        shard_idx,
        shards,
        success,
        parse_failures.len(),
        idempotency_failures.len()
    )
    .unwrap();

    // PF  shard  path  pass  trigger  status  msg
    for pf in parse_failures {
        let trigger = pf.trigger.as_deref().unwrap_or("UNKNOWN");
        let status = pf.status.as_deref().unwrap_or("UNKNOWN");
        writeln!(
            f,
            "PF\t{}\t{}\t{}\t{}\t{}\t{}",
            shard_idx, pf.path, pf.pass, trigger, status, pf.msg
        )
        .unwrap();
    }

    // IF  shard  path
    for p in idempotency_failures {
        writeln!(f, "IF\t{}\t{}", shard_idx, p).unwrap();
    }
}

fn run_sc_help_corpus_shard(shard_idx: usize, shards: usize) {
    // Skip if FIXTURE is set - user wants to run specific fixtures only
    if std::env::var("FIXTURE").is_ok() {
        eprintln!(
            "Skipping sc_help_corpus_shard_{} because FIXTURE is set",
            shard_idx
        );
        return;
    }

    let pattern = "tests/sc_help/**/*.scd";
    let mut paths: Vec<_> = glob(pattern).unwrap().map(|e| e.unwrap()).collect();
    paths.sort(); // deterministic sharding

    if paths.is_empty() {
        eprintln!("No sc_help corpus files found. Run extract_help_from_docs.py first.");
        return;
    }

    let mut parse_failures: Vec<ParseFailure> = Vec::new();
    let mut idempotency_failures: Vec<String> = Vec::new();
    let mut success_count = 0usize;

    for (i, path) in paths.iter().enumerate() {
        if (i % shards) != shard_idx {
            continue;
        }

        let input = std::fs::read_to_string(path).unwrap();

        let once = match run_cli_on_str_capture(&input) {
            Ok(out) => out,
            Err(e) => {
                parse_failures.push(ParseFailure {
                    path: path.display().to_string(),
                    pass: 1,
                    trigger: e.trigger_rule.clone(),
                    status: Some(e.status.to_string()),
                    msg: stderr_one_liner(&e.stderr),
                });
                continue;
            }
        };

        let twice = match run_cli_on_str_capture(&once) {
            Ok(out) => out,
            Err(e) => {
                parse_failures.push(ParseFailure {
                    path: path.display().to_string(),
                    pass: 2,
                    trigger: e.trigger_rule.clone(),
                    status: Some(e.status.to_string()),
                    msg: stderr_one_liner(&e.stderr),
                });
                continue;
            }
        };

        if once != twice {
            idempotency_failures.push(path.display().to_string());
        } else {
            success_count += 1;
        }
    }

    // Deterministic output ordering
    parse_failures.sort_by(|a, b| a.path.cmp(&b.path).then(a.pass.cmp(&b.pass)));
    idempotency_failures.sort();

    // Always write a TSV for this shard (even if it passes) so collation is easy.
    write_shard_tsv(
        shard_idx,
        shards,
        success_count,
        &parse_failures,
        &idempotency_failures,
    );

    eprintln!(
        "\n=== SC Help Corpus Shard {}/{} ===\nSuccess: {}\nParse failures: {}\nIdempotency failures: {}",
        shard_idx,
        shards,
        success_count,
        parse_failures.len(),
        idempotency_failures.len()
    );

    assert!(
        parse_failures.is_empty() && idempotency_failures.is_empty(),
        "Shard {}/{} failed. See {}",
        shard_idx,
        shards,
        shard_results_path(shard_idx).display()
    );
}

// IMPORTANT: seq! needs a literal range. Keep this in sync with SHARDS above.
seq!(N in 0..16 {
    #[test]
    fn sc_help_corpus_shard_~N() {
        run_sc_help_corpus_shard(N, SHARDS);
    }
});
