//! Formatting may move blanks and add or remove a few marks of punctuation.
//! It must never drop or change anything else: a name, a number, a string, a
//! comment, an operator's adverb. The idempotence tests cannot see such a
//! loss, because a rule that deletes something deletes it the same way twice.

use glob::glob;
use std::collections::BTreeMap;

/// What must survive formatting, counted: every word, and every other
/// character that is not a blank. Left out are the marks the rules add or
/// remove (`(` `)` `,` `;` `|`) and the word `arg`, which becomes a pair of
/// pipes. Counted and not kept in order, because that same rule moves the
/// parameters ahead of a comment that stood before them.
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

#[test]
fn formatting_keeps_every_token() {
    let mut lost = Vec::new();
    let mut checked = 0usize;
    for pattern in ["tests/fixtures/**/input.scd", "tests/sc_help/**/*.scd"] {
        for path in glob(pattern).unwrap().map(Result::unwrap) {
            let input = std::fs::read_to_string(&path).unwrap();
            // A file the formatter refuses is the other tests' business.
            let Ok(output) = sclang_format::format_source(&input, "all") else {
                continue;
            };
            checked += 1;
            let (before, after) = (essence(&input), essence(&output));
            if before != after {
                let differing: Vec<String> = before
                    .keys()
                    .chain(after.keys())
                    .filter(|k| before.get(*k) != after.get(*k))
                    .map(|k| {
                        format!(
                            "{k:?} {}->{}",
                            before.get(k).unwrap_or(&0),
                            after.get(k).unwrap_or(&0)
                        )
                    })
                    .collect::<std::collections::BTreeSet<_>>()
                    .into_iter()
                    .collect();
                lost.push(format!("{}: {}", path.display(), differing.join(", ")));
            }
        }
    }
    assert!(checked > 0, "no input files found");
    assert!(
        lost.is_empty(),
        "{} of {} files lost or changed text (token, times before -> after):\n{}",
        lost.len(),
        checked,
        lost.iter().take(25).cloned().collect::<Vec<_>>().join("\n")
    );
}
