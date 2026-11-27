//! Every short string of tokens, as sclang takes it.
//!
//! SuperCollider's source tests its own parser by brute force
//! (testsuite/sclang/lpc/TestParserBrutal.sc, by Brian Heim, 2017): an
//! alphabet of tokens, and every string of so many of them, compiled. The
//! alphabets here are written from that file: its `full` alphabet, bare and
//! inside a block as there, and its `mini` alphabet after the four openings
//! it is tested with there. There the strings are of four to seven tokens,
//! and what is recorded is sclang's bytecode from one version to the next.
//! Here they are of one to three, and sclang is the judge of this formatter.
//!
//! `token_strings` requires of every string sclang compiles, as it stands or
//! with the names it uses declared, that the grammar parses it without an
//! error, that the formatter takes it and is done in one pass, and that
//! sclang compiles what the formatter wrote to the same code. sclang only
//! compiles; no string is run. There are some 190,000 strings, so the test
//! runs only when asked for:
//!
//!     cargo test --test token_strings -- --ignored --nocapture
//!
//! What disagrees is written to target/judge/tokens/disagreements.txt,
//! grouped by cause: by what is wrong, and under that by the smallest form
//! that shows it, which is the shortest run of a string's own tokens that
//! fails in the same way, with ` x` written for each token that is a value
//! (`0 ^ abc` and `1.1 ^ nil` are both ` x ^ x`).
//!
//! The other direction, a string sclang refuses and the grammar takes, is
//! not looked for: tests/lang11d/refused.forms pins what is known of it.

mod common;

use common::judge::{
    Reason, compile_texts, declare, fresh_dir, manifest_dir, par_map, reason, sclang_or_skip,
    undeclared_names,
};
use std::collections::{BTreeMap, BTreeSet};
use std::fmt::Write;
use std::fs;
use tree_sitter::Parser;

/// The `full` alphabet of TestParserBrutal.sc. A token that may not follow
/// another directly has its blank in front, as it has there.
const FULL: &[&str] = &[
    // Brackets.
    "(", ")", "{", "}", "[", "]", // Keywords.
    " var", " arg", " true", " false", " nil", // Punctuation.
    " ;", " ,", " .", " `", " #", " !", " ..", " ...", " _", " <", " >", " -", " *", " +", " |",
    " <-", " ^",
    // Without a blank: `2 pow : 2` is not legal, and `=` makes `==` and `!=`.
    ":", "=", // Names.
    " Object", " abc", " def", " ~abc", " ~def", " var abc", " var def",
    // A message, and a keyword of one.
    ".size", " size:", // Literals.
    " $a", " \"str\"", " 'sym'", "0", "1.1", " pi",
];

/// Its `mini` alphabet, for what opens a function.
const MINI: &[&str] = &[" ;", " ,", " ...", " |", " var", " arg", " abc", " def"];

/// What the strings are made in: what stands before the tokens, what stands
/// after them, and the alphabet.
const SETS: &[(&str, &str, &[&str])] = &[
    ("", "", FULL),
    ("{", "}", FULL),
    ("var ", "", MINI),
    ("{var ", "}", MINI),
    ("{arg ", "}", MINI),
    ("{|", "}", MINI),
];

/// The most tokens in a string.
const LONGEST: usize = 3;

/// The tokens that are a value. Strings that differ only in which value
/// stands where fail for one cause.
const VALUES: &[&str] = &[
    " true", " false", " nil", " Object", " abc", " def", " ~abc", " ~def", " $a", " \"str\"",
    " 'sym'", "0", "1.1", " pi",
];

/// The smallest forms known to disagree, each with what is wrong. The test
/// tolerates exactly these; one that no longer disagrees must be removed.
const KNOWN_DISAGREEMENTS: &[&str] = &[
    // The grammar does not parse a return that follows an expression with no
    // semicolon between them, where the two are the whole text: `0 ^ abc`.
    // sclang reads the body of any function so (lang11d: funcbody is
    // `exprseq funretval`), and interpreted text is one. The grammar takes
    // it inside braces (`{ 0 ^ abc }`), and not at the top of a file, nor
    // after a block there: `{} ^{}`.
    " x ^ x", "{} ^{}",
    // The grammar does not parse a ref of empty parentheses, `` `() ``.
    // What a ref may hold is a list of its own in the grammar, and the
    // parentheses in it must hold an expression. `` `().size `` it does
    // parse, as a ref of the call.
    " `()", "{ `()}",
];

struct Text {
    /// Which of SETS it is made in, and of which tokens.
    set: usize,
    tokens: Vec<&'static str>,
    text: String,
}

fn text_of(set: usize, tokens: &[&str]) -> String {
    let (before, after, _) = SETS[set];
    format!("{before}{}{after}", tokens.concat())
}

/// Every string of one to LONGEST tokens of every set, each text once: two
/// strings of tokens may spell the same text.
fn texts() -> Vec<Text> {
    let mut seen = BTreeSet::new();
    let mut texts = Vec::new();
    for (set, (_, _, alphabet)) in SETS.iter().enumerate() {
        let mut strings: Vec<Vec<&'static str>> = vec![Vec::new()];
        for _ in 0..LONGEST {
            strings = strings
                .iter()
                .flat_map(|string| {
                    alphabet
                        .iter()
                        .map(move |token| [&string[..], &[*token]].concat())
                })
                .collect();
            for tokens in &strings {
                let text = text_of(set, tokens);
                if seen.insert(text.clone()) {
                    texts.push(Text {
                        set,
                        tokens: tokens.clone(),
                        text,
                    });
                }
            }
        }
    }
    texts
}

#[test]
#[ignore = "has sclang compile some 190,000 strings; needs sclang"]
fn token_strings() {
    if !sclang_or_skip("token_strings") {
        return;
    }
    let work = fresh_dir(&manifest_dir().join("target/judge/tokens"));
    let texts = texts();
    let all: Vec<String> = texts.iter().map(|t| t.text.clone()).collect();

    // sclang's verdict on each: the code it compiles to, and the names that
    // had to be declared for it. A string refused only for names it does
    // not declare is compiled again with them declared.
    let mut accepted: BTreeMap<usize, (String, Vec<String>)> = BTreeMap::new();
    let mut retry = Vec::new();
    for (i, compiled) in compile_texts(&all, &work).into_iter().enumerate() {
        match compiled.dump {
            Some(dump) => {
                accepted.insert(i, (dump, Vec::new()));
            }
            None if reason(&compiled.errors) == Reason::UndeclaredName => {
                retry.push((i, undeclared_names(&compiled.errors)));
            }
            None => {}
        }
    }
    let declared: Vec<String> = retry
        .iter()
        .map(|(i, names)| declare(names, &all[*i]))
        .collect();
    for ((i, names), compiled) in retry.into_iter().zip(compile_texts(&declared, &work)) {
        if let Some(dump) = compiled.dump {
            accepted.insert(i, (dump, names));
        }
    }

    // Each string sclang accepts, formatted; or what is wrong with it.
    let indices: Vec<usize> = accepted.keys().copied().collect();
    let formatted = par_map(&indices, |i| {
        let text = &all[*i];
        let mut parser = Parser::new();
        parser
            .set_language(&sclang_format::grammar::language())
            .unwrap();
        if parser.parse(text, None).unwrap().root_node().has_error() {
            return Err(("the grammar does not parse it", String::new()));
        }
        let once = sclang_format::format_source(text)
            .map_err(|e| ("the formatter refuses it", format!("{e:#}")))?;
        match sclang_format::format_source(&once) {
            Ok(twice) if twice == once => Ok(once),
            Ok(twice) => Err(("a second pass changes it", format!("{once:?} to {twice:?}"))),
            Err(e) => Err((
                "the formatter refuses what it wrote",
                format!("{once:?}: {e:#}"),
            )),
        }
    });
    let mut faults: BTreeMap<usize, (&str, String)> = BTreeMap::new();
    let mut written = Vec::new();
    for (i, formatted) in indices.iter().zip(formatted) {
        match formatted {
            Ok(once) => written.push((*i, once)),
            Err(fault) => {
                faults.insert(*i, fault);
            }
        }
    }
    let to_compile: Vec<String> = written
        .iter()
        .map(|(i, once)| match &accepted[i].1 {
            names if names.is_empty() => once.clone(),
            names => declare(names, once),
        })
        .collect();
    for ((i, once), compiled) in written.iter().zip(compile_texts(&to_compile, &work)) {
        match compiled.dump {
            Some(dump) if dump == accepted[i].0 => {}
            Some(_) => {
                faults.insert(
                    *i,
                    (
                        "it means something else once formatted",
                        format!("{once:?}"),
                    ),
                );
            }
            None => {
                faults.insert(
                    *i,
                    ("sclang refuses it once formatted", format!("{once:?}")),
                );
            }
        }
    }

    // The smallest form of each fault: the shortest run of the string's own
    // tokens that fails in the same way, the first of them where several do,
    // with ` x` for each value.
    let by_text: BTreeMap<&str, usize> = all
        .iter()
        .enumerate()
        .map(|(i, text)| (text.as_str(), i))
        .collect();
    let smallest = |i: usize| -> String {
        let (text, kind) = (&texts[i], faults[&i].0);
        let run = (1..text.tokens.len())
            .flat_map(|len| text.tokens.windows(len))
            .find(|run| {
                by_text
                    .get(text_of(text.set, run).as_str())
                    .and_then(|at| faults.get(at))
                    .is_some_and(|fault| fault.0 == kind)
            })
            .unwrap_or(&text.tokens);
        let shape: Vec<&str> = run
            .iter()
            .map(|token| if VALUES.contains(token) { " x" } else { token })
            .collect();
        text_of(text.set, &shape)
    };
    let mut causes: BTreeMap<(&str, String), Vec<usize>> = BTreeMap::new();
    for (i, (kind, _)) in &faults {
        causes.entry((kind, smallest(*i))).or_default().push(*i);
    }

    let mut report = String::new();
    for ((kind, form), strings) in &causes {
        writeln!(report, "{kind}: {form:?} ({} strings)", strings.len()).unwrap();
        for i in strings {
            let line = format!("    {:?}  {}", all[*i], faults[i].1);
            writeln!(report, "{}", line.trim_end()).unwrap();
        }
    }
    let path = work.join("disagreements.txt");
    fs::write(&path, report).unwrap();

    eprintln!("\n=== Strings of tokens ===");
    eprintln!(
        "{} strings; sclang compiles {}, {} of them with names declared",
        all.len(),
        accepted.len(),
        accepted
            .values()
            .filter(|(_, names)| !names.is_empty())
            .count()
    );
    eprintln!(
        "Taken by the formatter and done in one pass: {}; disagreeing: {}, of {} causes",
        written.len(),
        faults.len(),
        causes.len()
    );
    eprintln!("Details: {}", path.display());

    let found: BTreeSet<&str> = causes.keys().map(|(_, form)| form.as_str()).collect();
    let stale: Vec<&&str> = KNOWN_DISAGREEMENTS
        .iter()
        .filter(|form| !found.contains(**form))
        .collect();
    let unexpected: String = causes
        .iter()
        .filter(|((_, form), _)| !KNOWN_DISAGREEMENTS.contains(&form.as_str()))
        .map(|((kind, form), strings)| format!("  {kind}: {form:?} ({} strings)\n", strings.len()))
        .collect();
    assert!(
        stale.is_empty(),
        "KNOWN_DISAGREEMENTS lists forms that no longer disagree; remove them: {stale:?}"
    );
    assert!(
        unexpected.is_empty(),
        "sclang compiles these and the formatter fails on them (see {}):\n{unexpected}",
        path.display()
    );
}
