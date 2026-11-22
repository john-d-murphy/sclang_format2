//! Formatting may move blanks and add or remove a few marks of punctuation.
//! It must never drop or change anything else: a name, a number, a string, a
//! comment, an operator's adverb. The idempotence tests cannot see such a
//! loss, because a rule that deletes something deletes it the same way twice.

mod common;

use common::tokens::changed_tokens;
use glob::glob;

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
            let changed = changed_tokens(&input, &output);
            if !changed.is_empty() {
                lost.push(format!("{}: {}", path.display(), changed.join(", ")));
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
