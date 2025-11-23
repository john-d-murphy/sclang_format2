use anyhow::Result;
use std::io::Write;
use std::process::{Command, Stdio};

pub fn run_cli_on_str(input: &str) -> Result<String> {
    // ✅ macro form (not deprecated)
    let mut cmd = Command::new(assert_cmd::cargo::cargo_bin!("sclang_format"));
    cmd.stdin(Stdio::piped()).stdout(Stdio::piped());

    let mut child = cmd.spawn()?;
    child.stdin.as_mut().unwrap().write_all(input.as_bytes())?;
    let out = child.wait_with_output()?;

    anyhow::ensure!(out.status.success(), "formatter non-zero: {}", out.status);
    Ok(String::from_utf8(out.stdout)?)
}
