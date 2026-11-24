// Each test crate uses only some of these helpers.
#![allow(dead_code)]

pub mod forms;
pub mod judge;
pub mod tokens;

use anyhow::Result;
use std::io::Write;
use std::path::PathBuf;
use std::process::{Command, Stdio};

/// Where the tests that read SuperCollider's own source look for it, from
/// the crate's directory, and the command that puts it there: the source at
/// the tag of the version installed. target/ is not committed. The source is
/// only read; nothing in it is built or run.
pub const SC_SOURCE: &str = "target/sc-source";
pub const FETCH_SC_SOURCE: &str = "git clone --depth 1 --branch Version-3.14.1 \
     https://github.com/supercollider/supercollider target/sc-source";

/// Says that `test` is skipped and why, where an ordinary `cargo test` shows
/// it: libtest keeps back what a passing test prints with `eprintln!`, and
/// does not see a write to the stream itself.
pub fn skip(test: &str, reason: &str) {
    let _ = writeln!(std::io::stderr(), "SKIPPED {test}: {reason}");
}

/// SuperCollider's source; or, when it is not there, nothing, after saying
/// that `test` is skipped for want of it.
pub fn sc_source(test: &str) -> Option<PathBuf> {
    let source = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join(SC_SOURCE);
    if source.is_dir() {
        return Some(source);
    }
    skip(
        test,
        &format!(
            "no SuperCollider source at {}; to fetch it, from the crate's directory: \
             {FETCH_SC_SOURCE}",
            source.display()
        ),
    );
    None
}

pub fn run_cli_on_str(input: &str) -> Result<String> {
    // ✅ macro form (not deprecated)
    let mut cmd = Command::new(assert_cmd::cargo::cargo_bin!("sclang_format"));
    // What the formatter says of a text it refuses goes into the error, not
    // onto the terminal: a refusal that a test expects is no news.
    cmd.stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped());

    let mut child = cmd.spawn()?;
    child.stdin.as_mut().unwrap().write_all(input.as_bytes())?;
    let out = child.wait_with_output()?;

    anyhow::ensure!(
        out.status.success(),
        "formatter non-zero: {}: {}",
        out.status,
        String::from_utf8_lossy(&out.stderr).trim()
    );
    Ok(String::from_utf8(out.stdout)?)
}
