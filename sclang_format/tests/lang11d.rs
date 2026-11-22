//! SuperCollider's own grammar as a checklist for ours.
//!
//! `tests/lang11d/interpreted.forms` and `tests/lang11d/classes.forms` hold,
//! under each production of sclang's Bison grammar
//! (lang/LangSource/Bison/lang11d), the shortest code that reaches it. The
//! help corpus shows what people write; these show what the language is.
//!
//! - `interpreted_forms_keep_their_meaning` and
//!   `class_forms_keep_their_meaning` require of every form that sclang
//!   compiles it, that our grammar parses it without an error, that the
//!   formatter takes it and is done after one pass, and that sclang compiles
//!   the formatted form to the same thing. They need sclang and skip, saying
//!   so, when it is not installed.
//! - `every_production_has_a_form` reads the Bison grammar itself and
//!   requires each of its productions to be a heading in one of the two
//!   files. It needs SuperCollider's source, at the tag of the version
//!   installed, and skips, saying so, when the source is not there. To
//!   fetch it, from this directory (target/ is not committed):
//!
//!       git clone --depth 1 --branch Version-3.14.1 \
//!           https://github.com/supercollider/supercollider target/sc-source
//!
//!   The source is only read. Nothing in it is built or run.
//!
//! A forms file is read like this. A line that begins `== ` is a heading: a
//! production, written as the Bison file writes it, or `lexer ...` for
//! something the lexer does. Headings that follow one another share what
//! comes under them. Under the headings come the forms, one to a paragraph,
//! or a line that begins `-- ` and says why no form can reach the
//! production. What stands before the first heading is the file's own
//! introduction.

mod common;

use common::judge::{
    Verdict, compile_all, compile_classes, declare, fresh_dir, judge, manifest_dir,
    sclang_installed,
};
use std::collections::{BTreeMap, BTreeSet};
use std::fs;
use std::path::{Path, PathBuf};
use tree_sitter::Parser;

/// Where SuperCollider's source is looked for, and how to put it there.
const SC_SOURCE: &str = "target/sc-source";
const FETCH: &str = "git clone --depth 1 --branch Version-3.14.1 \
                     https://github.com/supercollider/supercollider target/sc-source";

struct Group {
    headings: Vec<String>,
    forms: Vec<String>,
    /// Why no form reaches these productions, where none does.
    excuse: Option<String>,
}

fn groups(file: &str) -> Vec<Group> {
    let path = manifest_dir().join("tests/lang11d").join(file);
    let text = fs::read_to_string(&path).unwrap();
    let mut groups: Vec<Group> = Vec::new();
    let mut form: Vec<&str> = Vec::new();
    // A blank line, a heading and the end of the file each end a form.
    let end_form = |groups: &mut Vec<Group>, form: &mut Vec<&str>| {
        if let (Some(group), false) = (groups.last_mut(), form.is_empty()) {
            group.forms.push(form.join("\n"));
        }
        form.clear();
    };
    for line in text.lines() {
        if let Some(heading) = line.strip_prefix("== ") {
            end_form(&mut groups, &mut form);
            match groups.last_mut() {
                Some(group) if group.forms.is_empty() && group.excuse.is_none() => {
                    group.headings.push(heading.trim().to_string());
                }
                _ => groups.push(Group {
                    headings: vec![heading.trim().to_string()],
                    forms: Vec::new(),
                    excuse: None,
                }),
            }
        } else if let Some(excuse) = line.strip_prefix("-- ") {
            let group = groups.last_mut().expect("an excuse before any heading");
            group.excuse = Some(excuse.to_string());
        } else if line.trim().is_empty() {
            end_form(&mut groups, &mut form);
        } else {
            form.push(line);
        }
    }
    end_form(&mut groups, &mut form);
    for group in &groups {
        assert!(
            group.forms.is_empty() != group.excuse.is_none(),
            "{file}: under {:?} there must be forms, or one line saying why there are none",
            group.headings
        );
    }
    groups
}

/// Every form of a file, with the first of its headings to name it by.
fn forms(file: &str) -> Vec<(String, String)> {
    groups(file)
        .into_iter()
        .flat_map(|group| {
            let heading = group.headings[0].clone();
            group
                .forms
                .into_iter()
                .map(move |form| (heading.clone(), form))
        })
        .collect()
}

fn parser() -> Parser {
    let mut parser = Parser::new();
    parser
        .set_language(&sclang_format::grammar::language())
        .unwrap();
    parser
}

/// The form formatted, or what is wrong with it before sclang is asked:
/// the grammar does not parse it, the formatter refuses it, or a second
/// pass changes it again.
fn formatted(parser: &mut Parser, form: &str) -> Result<String, String> {
    let tree = parser.parse(form, None).unwrap();
    if tree.root_node().has_error() {
        return Err(format!(
            "the grammar does not parse it: {}",
            tree.root_node().to_sexp()
        ));
    }
    let once = sclang_format::format_source(form, "all")
        .map_err(|e| format!("the formatter refuses it: {e:#}"))?;
    match sclang_format::format_source(&once, "all") {
        Ok(twice) if twice == once => Ok(once),
        Ok(twice) => Err(format!(
            "a second pass changes it: {once:?} becomes {twice:?}"
        )),
        Err(e) => Err(format!("the formatter refuses its own output {once:?}: {e:#}")),
    }
}

fn report(what: &str, count: usize, faults: &[String]) {
    eprintln!("{what}: {count} forms, {} faults", faults.len());
    assert!(
        faults.is_empty(),
        "\n{} of {count} forms fail:\n\n{}",
        faults.len(),
        faults.join("\n\n")
    );
}

/// Requires of each form (heading, text) what the top of this file says,
/// with `work` for the files sclang reads.
fn check_interpreted(what: &str, forms: &[(String, String)], work: &Path) {
    let name = |i: usize| PathBuf::from(format!("{i:04}.scd"));

    let original_dir = fresh_dir(&work.join("original"));
    for (i, (_, form)) in forms.iter().enumerate() {
        fs::write(original_dir.join(name(i)), form).unwrap();
    }
    let verdicts = judge(&original_dir, work);

    let mut parser = parser();
    let formatted_dir = fresh_dir(&work.join("formatted"));
    let mut faults = BTreeMap::new();
    let mut originals = BTreeMap::new();
    for (i, (_, form)) in forms.iter().enumerate() {
        let (dump, declared) = match &verdicts[&name(i)] {
            Verdict::Accepted { dump, declared } => (dump, declared),
            Verdict::Refused { error, .. } => {
                faults.insert(i, format!("sclang refuses it: {error}"));
                continue;
            }
        };
        match formatted(&mut parser, form) {
            Ok(text) => {
                let text = if declared.is_empty() {
                    text
                } else {
                    declare(declared, &text)
                };
                fs::write(formatted_dir.join(name(i)), text).unwrap();
                originals.insert(i, dump);
            }
            Err(fault) => {
                faults.insert(i, fault);
            }
        }
    }
    let compiled = compile_all(&formatted_dir, work);
    for (i, original) in originals {
        let text = fs::read_to_string(formatted_dir.join(name(i))).unwrap();
        match &compiled[&name(i)].dump {
            Some(dump) if dump == original => {}
            Some(_) => {
                faults.insert(i, format!("it means something else once formatted: {text:?}"));
            }
            None => {
                faults.insert(i, format!("sclang refuses it once formatted: {text:?}"));
            }
        }
    }

    let faults: Vec<String> = faults
        .into_iter()
        .map(|(i, fault)| format!("{}\n  [{}]\n  {fault}", forms[i].1, forms[i].0))
        .collect();
    report(what, forms.len(), &faults);
}

#[test]
fn interpreted_forms_keep_their_meaning() {
    if !sclang_installed() {
        eprintln!("Skipping interpreted_forms_keep_their_meaning: sclang is not installed");
        return;
    }
    check_interpreted(
        "interpreted forms",
        &forms("interpreted.forms"),
        &fresh_dir(&manifest_dir().join("target/judge/lang11d/interpreted")),
    );
}

/// Characters, symbols and strings that hold what a rule might take for
/// structure if it read bytes and not the tree: quotes, brackets, a pipe, a
/// comma, the start of a comment. The quotes come in pairs, so that a rule
/// which counts them still takes the form after the list for code.
const AWKWARD_BEFORE: &str = concat!(
    "[$\", $\", $', $', ${, $(, $[, $|, $/, $*, $,, $;, $ , $\\\\, ",
    "\"{([|,;//\", '{([|,;/*', \"/* \", '/*', \"//\", \\a];"
);
const AWKWARD_AFTER: &str = "[$}, $), $], \"*/})]\"]";

/// Each form again, between two lists of awkward literals. The lists change
/// nothing about the form; a rule that loses its place in them will refuse
/// the form, or spoil it.
#[test]
fn interpreted_forms_keep_their_meaning_among_awkward_literals() {
    if !sclang_installed() {
        eprintln!(
            "Skipping interpreted_forms_keep_their_meaning_among_awkward_literals: \
             sclang is not installed"
        );
        return;
    }
    // Arguments and variables must come first and nothing may follow a
    // return, so a form that opens with any of them is left out.
    let stands_alone = |form: &str| {
        let top = form.trim_start_matches(['(', ' ']);
        ["arg ", "var ", "|", "^"].iter().any(|opening| top.starts_with(opening))
    };
    let forms: Vec<(String, String)> = forms("interpreted.forms")
        .into_iter()
        .filter(|(_, form)| !stands_alone(form))
        .map(|(heading, form)| {
            // The second list is one more expression, after a semicolon if
            // the form does not end with its own.
            let semicolon = if form.trim_end().ends_with(';') { "" } else { "; " };
            let form = format!("{AWKWARD_BEFORE}\n{form}\n{semicolon}{AWKWARD_AFTER}");
            (heading, form)
        })
        .collect();
    check_interpreted(
        "interpreted forms among awkward literals",
        &forms,
        &fresh_dir(&manifest_dir().join("target/judge/lang11d/awkward")),
    );
}

#[test]
fn class_forms_keep_their_meaning() {
    if !sclang_installed() {
        eprintln!("Skipping class_forms_keep_their_meaning: sclang is not installed");
        return;
    }
    let forms = forms("classes.forms");
    let work = fresh_dir(&manifest_dir().join("target/judge/lang11d/classes"));
    let name = |i: usize| format!("/{i:04}.sc");

    let mut parser = parser();
    let original_dir = fresh_dir(&work.join("original"));
    let formatted_dir = fresh_dir(&work.join("formatted"));
    let mut faults = BTreeMap::new();
    for (i, (_, form)) in forms.iter().enumerate() {
        fs::write(original_dir.join(&name(i)[1..]), form).unwrap();
        // A form with a fault is compiled as it stands the second time too,
        // so that its fault is the only one reported for it.
        let text = formatted(&mut parser, form).unwrap_or_else(|fault| {
            faults.insert(i, fault);
            form.clone()
        });
        fs::write(formatted_dir.join(&name(i)[1..]), text).unwrap();
    }

    // What the class library holds from each file: its lines, by file.
    let by_file = |dir: &Path, work: &Path| -> BTreeMap<String, BTreeSet<String>> {
        let lines = compile_classes(dir, work, true).unwrap_or_else(|said| {
            panic!(
                "sclang did not compile the class files in {}; it said:\n{said}",
                dir.display()
            )
        });
        let mut files: BTreeMap<String, BTreeSet<String>> = BTreeMap::new();
        for line in lines {
            let file = line.split(' ').nth(1).unwrap().to_string();
            files.entry(file).or_default().insert(line);
        }
        files
    };
    let original = by_file(&original_dir, &fresh_dir(&work.join("original-work")));
    let formatted = by_file(&formatted_dir, &fresh_dir(&work.join("formatted-work")));
    for i in 0..forms.len() {
        if original.get(&name(i)) != formatted.get(&name(i)) {
            let text = fs::read_to_string(formatted_dir.join(&name(i)[1..])).unwrap();
            faults
                .entry(i)
                .or_insert_with(|| format!("it means something else once formatted: {text:?}"));
        }
    }

    let faults: Vec<String> = faults
        .into_iter()
        .map(|(i, fault)| format!("{}\n  [{}]\n  {fault}", forms[i].1, forms[i].0))
        .collect();
    report("class forms", forms.len(), &faults);
}

/// The productions of a Bison grammar, each as `name: its symbols`, an empty
/// one as `name: (empty)`. What stands in braces is the action and is left
/// out, and a quoted brace is not one.
fn productions(bison: &str) -> Vec<String> {
    let rules: Vec<char> = bison
        .split_once("\n%%")
        .expect("no %% in the grammar")
        .1
        .chars()
        .collect();
    let mut text = String::new();
    let mut depth = 0;
    let mut i = 0;
    while i < rules.len() {
        match rules[i] {
            // A quoted character, `'{'` or `'|'`: a word of its own. The bar
            // and the semicolon are spelled out, so that the one does not
            // part two alternatives nor the other end a rule.
            '\'' if rules.get(i + 2) == Some(&'\'') => {
                if depth == 0 {
                    text.push_str(&match rules[i + 1] {
                        '|' => " 'BAR' ".to_string(),
                        ';' => " 'SEMICOLON' ".to_string(),
                        quoted => format!(" '{quoted}' "),
                    });
                }
                i += 2;
            }
            '{' => depth += 1,
            '}' => depth -= 1,
            c if depth == 0 => text.push(c),
            _ => {}
        }
        i += 1;
    }

    let mut productions = Vec::new();
    let mut name = String::new();
    for alternative in text.replace(';', " ").split('|') {
        // A rule's name and colon may open the alternative; the grammar ends
        // most rules with a semicolon and some with nothing.
        let mut words: Vec<&str> = alternative.split_whitespace().collect();
        while let Some(at) = words.iter().position(|w| *w == ":") {
            if at > 1 {
                productions.push(production(&name, &words[..at - 1]));
            }
            name = words[at - 1].to_string();
            words.drain(..=at);
        }
        productions.push(production(&name, &words));
    }
    productions
}

fn production(name: &str, symbols: &[&str]) -> String {
    if symbols.is_empty() {
        format!("{name}: (empty)")
    } else {
        let symbols = symbols.join(" ");
        format!(
            "{name}: {}",
            symbols.replace("'BAR'", "'|'").replace("'SEMICOLON'", "';'")
        )
    }
}

#[test]
fn every_production_has_a_form() {
    let bison = manifest_dir()
        .join(SC_SOURCE)
        .join("lang/LangSource/Bison/lang11d");
    let Ok(bison) = fs::read_to_string(&bison) else {
        eprintln!(
            "Skipping every_production_has_a_form: no SuperCollider source at {}. \
             To fetch it: {FETCH}",
            bison.display()
        );
        return;
    };
    let productions: BTreeSet<String> = productions(&bison).into_iter().collect();
    let headings: BTreeSet<String> = ["interpreted.forms", "classes.forms"]
        .iter()
        .flat_map(|file| groups(file))
        .flat_map(|group| group.headings)
        .collect();

    let without: Vec<&String> = productions.difference(&headings).collect();
    let unknown: Vec<&String> = headings
        .difference(&productions)
        .filter(|heading| !heading.starts_with("lexer "))
        .collect();
    eprintln!(
        "lang11d: {} productions, {} headings",
        productions.len(),
        headings.len()
    );
    assert!(
        without.is_empty() && unknown.is_empty(),
        "\nProductions of lang11d with no heading in tests/lang11d/*.forms:\n{}\n\
         Headings that are neither a production nor `lexer ...`:\n{}",
        without.iter().map(|p| format!("  {p}\n")).collect::<String>(),
        unknown.iter().map(|h| format!("  {h}\n")).collect::<String>()
    );
}
