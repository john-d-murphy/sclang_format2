//! SuperCollider's own examples, formatted: whole files as they are written
//! for a piece, many regions in parentheses one after another, comments and
//! loose lines between them, long functions. The help corpus is single forms
//! cut from such files; the class library is class files.
//!
//! The examples are read where they are installed and nothing is written
//! there; what sclang is given to compile goes under target/judge/examples.
//! The test skips, saying so, when the examples or sclang are not there.
//! sclang only compiles (tests/judge.scd): no example is ever run.
//!
//! What is SuperCollider, for a whole file. sclang refuses a file of regions
//! read as one text, at its second `(`, so it cannot judge such a file
//! whole. The file is judged the way it is used: in its units, as
//! `sclang_format::units` tells them (the regions an editor would send to
//! sclang, and the loose code between them), each compiled by itself. A unit
//! refused only for names it does not declare is compiled again with those
//! names declared, as in tests/sclang_judge.rs. A file is SuperCollider
//! unless its brackets do not pair, so that its regions cannot be told, or
//! sclang finds a syntax error in one of its regions (in the whole of it,
//! where it has none). Loose code does not count: lines written to be
//! evaluated one at a time (`x = Synth(\a)` and under it `x.free`) are no
//! program together, sclang refuses them, and the formatter leaves them as
//! they are written. Nor does a region sclang refuses for a class this
//! machine does not have.
//!
//! Required of every file:
//! 1. where it is SuperCollider, the formatter takes it;
//! 2. a second pass changes nothing;
//! 3. no token is lost or changed (tests/common/tokens.rs);
//! 4. it has the same units once formatted, and every unit sclang compiles
//!    as it stands compiles to the same code once formatted. So does the
//!    whole file, where sclang compiles it whole.

mod common;

use common::judge::{
    Reason, Verdict, compile_all, declare, fresh_dir, judge, manifest_dir, sclang_or_skip,
};
use common::tokens::changed_tokens;
use std::collections::BTreeMap;
use std::fs;
use std::path::{Path, PathBuf};

const EXAMPLES: &str = "/usr/share/SuperCollider/examples";

/// Examples that are not SuperCollider, each with why. The test requires the
/// examples it finds not to be SuperCollider to be exactly these, so that a
/// fault in how the units of a file are told cannot pass for one in the file.
const NOT_SUPERCOLLIDER: &[&str] = &[
    // Line 64 is `}.play))`: its second `)` closes nothing. sclang refuses
    // the region, and the formatter the file, naming the line.
    "demonstrations/SC2-examples_2.scd",
];

/// Examples the formatter is known to fail on, each with what is wrong. The
/// test tolerates exactly these files; one that no longer fails must be
/// removed. To see the faults afresh, empty the list and run the test.
const KNOWN_FAULTS: &[&str] = &[
    // A second pass changes it. Some of its lines end in a carriage return
    // alone, as files from the old Mac OS do. The grammar takes a carriage
    // return for a blank, and so do the rules: one before a line break the
    // formatter writes is left standing at the end of the line, and one
    // before a line break it finds is taken away or left, as the rule at
    // work there has it. `{ a;\rb;\r}` comes out as `{\n    a;\r\n    b\r\n}`
    // and from a second pass as `{\n    a;\r\n    b\n}`. What the formatter
    // is to do with carriage returns has not been decided: a file with
    // `\r\n` for its line breaks comes out with some of each.
    "demonstrations/bit_reduction.scd",
];

/// An example as the test holds it: its path from the examples' folder, its
/// text, and its units' texts (none where the units cannot be told).
struct Example {
    name: String,
    text: String,
    units: Vec<String>,
}

/// The texts of the units of `text`; nothing where they cannot be told. A
/// file that is one program has one unit, the whole of it, and that is
/// compiled as the whole already.
fn units(text: &str) -> Vec<String> {
    match sclang_format::units(text) {
        Ok(units) if units.len() > 1 || units[0].kind != sclang_format::UnitKind::Program => units
            .iter()
            .map(|unit| text[unit.bytes.clone()].to_string())
            .collect(),
        _ => Vec::new(),
    }
}

/// Where the whole of example `i` is written for sclang, and its unit `k`.
/// The examples' own names hold blanks and quotes, so numbers stand for them.
fn whole(i: usize) -> PathBuf {
    PathBuf::from(format!("{i:02}/whole.scd"))
}
fn unit(i: usize, k: usize) -> PathBuf {
    PathBuf::from(format!("{i:02}/unit-{k:03}.scd"))
}

fn write(path: &Path, text: &str) {
    fs::create_dir_all(path.parent().unwrap()).unwrap();
    fs::write(path, text).unwrap();
}

#[test]
fn examples_format_cleanly_and_keep_their_meaning() {
    const TEST: &str = "examples_format_cleanly_and_keep_their_meaning";
    if !Path::new(EXAMPLES).is_dir() {
        common::skip(TEST, &format!("no examples at {EXAMPLES}"));
        return;
    }
    if !sclang_or_skip(TEST) {
        return;
    }
    let mut paths: Vec<PathBuf> = ["scd", "sc"]
        .iter()
        .flat_map(|ext| glob::glob(&format!("{EXAMPLES}/**/*.{ext}")).unwrap())
        .map(Result::unwrap)
        .collect();
    paths.sort();
    assert!(!paths.is_empty(), "no .scd or .sc files under {EXAMPLES}");
    let examples: Vec<Example> = paths
        .iter()
        .map(|path| {
            let text = fs::read_to_string(path).unwrap();
            Example {
                name: path.strip_prefix(EXAMPLES).unwrap().display().to_string(),
                units: units(&text),
                text,
            }
        })
        .collect();

    // sclang's verdict on each example whole and on each of its units.
    let work = fresh_dir(&manifest_dir().join("target/judge/examples"));
    let original_dir = fresh_dir(&work.join("original"));
    for (i, example) in examples.iter().enumerate() {
        write(&original_dir.join(whole(i)), &example.text);
        for (k, text) in example.units.iter().enumerate() {
            write(&original_dir.join(unit(i, k)), text);
        }
    }
    let verdicts = judge(&original_dir, &work);
    let syntax_error = |path: &PathBuf| match &verdicts[path] {
        Verdict::Refused {
            reason: Reason::SyntaxError,
            error,
        } => Some(error.clone()),
        _ => None,
    };

    // Each example formatted, and what is wrong with it before sclang is
    // asked a second time. The formatted units are written for sclang with
    // the names declared that the originals needed.
    let formatted_dir = fresh_dir(&work.join("formatted"));
    let mut faults: BTreeMap<usize, Vec<String>> = BTreeMap::new();
    let mut not_supercollider = Vec::new();
    let mut taken = 0usize;
    for (i, example) in examples.iter().enumerate() {
        let mut fault = |what: String| faults.entry(i).or_default().push(what);
        // Why the file is not SuperCollider, where it is not.
        let refusal = match sclang_format::units(&example.text) {
            Err(e) => Some(format!("{e:#}")),
            Ok(found) if example.units.is_empty() => syntax_error(&whole(i)).map(|error| {
                let line = found[0].lines.0;
                format!("sclang: {error} (the file is one program, from line {line})")
            }),
            Ok(found) => found
                .iter()
                .enumerate()
                .filter(|(_, unit)| unit.kind == sclang_format::UnitKind::Region)
                .find_map(|(k, region)| {
                    let error = syntax_error(&unit(i, k))?;
                    let line = region.lines.0;
                    Some(format!("sclang: {error} (the region at line {line})"))
                }),
        };
        if let Some(why) = &refusal {
            not_supercollider.push((example.name.as_str(), why.clone()));
        }
        let once = match sclang_format::format_source(&example.text) {
            Ok(once) => once,
            Err(e) => {
                if refusal.is_none() {
                    fault(format!("refused: {e:#}"));
                }
                continue;
            }
        };
        taken += 1;
        match sclang_format::format_source(&once) {
            Ok(twice) if twice != once => fault("a second pass changes it".to_string()),
            Ok(_) => {}
            Err(e) => fault(format!("second pass refused: {e:#}")),
        }
        let changed = changed_tokens(&example.text, &once);
        if !changed.is_empty() {
            fault(format!("tokens changed: {}", changed.join(", ")));
        }
        let formatted_units = units(&once);
        if formatted_units.len() != example.units.len() {
            fault(format!(
                "it has {} units and {} once formatted",
                example.units.len(),
                formatted_units.len()
            ));
            continue;
        }
        let texts = std::iter::once((whole(i), &once))
            .chain((0..).map(|k| unit(i, k)).zip(&formatted_units));
        for (path, text) in texts {
            match &verdicts[&path] {
                Verdict::Accepted { declared, .. } if !declared.is_empty() => {
                    write(&formatted_dir.join(path), &declare(declared, text));
                }
                _ => write(&formatted_dir.join(path), text),
            }
        }
    }

    // What sclang compiled as it stood must compile to the same code.
    let compiled = compile_all(&formatted_dir, &work);
    let mut compared = 0usize;
    for (path, after) in &compiled {
        let Verdict::Accepted { dump, .. } = &verdicts[path] else {
            continue;
        };
        compared += 1;
        let how = match &after.dump {
            Some(formatted) if formatted == dump => continue,
            Some(_) => "means something else once formatted".to_string(),
            None => format!(
                "sclang refuses it once formatted: {}",
                after.errors.join(" | ")
            ),
        };
        let i: usize = path
            .iter()
            .next()
            .unwrap()
            .to_str()
            .unwrap()
            .parse()
            .unwrap();
        faults.entry(i).or_default().push(format!(
            "{} {how} (see {} and the same under original/)",
            path.file_name().unwrap().to_string_lossy(),
            formatted_dir.join(path).display()
        ));
    }

    let accepted = |whole_only: bool| {
        verdicts
            .iter()
            .filter(|(path, _)| path.ends_with("whole.scd") == whole_only)
            .filter(|(_, verdict)| matches!(verdict, Verdict::Accepted { .. }))
            .count()
    };
    eprintln!("\n=== The examples ===");
    eprintln!(
        "{} files, {} sclang compiles whole; {} units of files it does not, {} sclang compiles",
        examples.len(),
        accepted(true),
        examples.iter().map(|e| e.units.len()).sum::<usize>(),
        accepted(false)
    );
    eprintln!("Not SuperCollider: {}", not_supercollider.len());
    for (name, why) in &not_supercollider {
        eprintln!("  {name}: {why}");
    }
    eprintln!(
        "Taken by the formatter: {taken}; compiled before and after: {compared}; \
         files with a fault: {}",
        faults.len()
    );

    let named: BTreeMap<&str, &Vec<String>> = faults
        .iter()
        .map(|(i, faults)| (examples[*i].name.as_str(), faults))
        .collect();
    let stale: Vec<&&str> = KNOWN_FAULTS
        .iter()
        .filter(|name| !named.contains_key(**name))
        .collect();
    let unexpected: String = named
        .iter()
        .filter(|(name, _)| !KNOWN_FAULTS.contains(name))
        .flat_map(|(name, faults)| faults.iter().map(move |fault| format!("{name}: {fault}\n")))
        .collect();
    let not_supercollider: Vec<&str> = not_supercollider.iter().map(|(name, _)| *name).collect();
    assert_eq!(
        not_supercollider, NOT_SUPERCOLLIDER,
        "the examples that are not SuperCollider are not those of NOT_SUPERCOLLIDER"
    );
    assert!(
        stale.is_empty(),
        "KNOWN_FAULTS lists examples that no longer fail; remove them: {stale:?}"
    );
    assert!(unexpected.is_empty(), "\n{unexpected}");
}
