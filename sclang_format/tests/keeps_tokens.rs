//! Formatting may move blanks and add or remove a few marks of punctuation.
//! It must never drop or change anything else: a name, a number, a string, a
//! comment, an operator's adverb. The idempotence tests cannot see such a
//! loss, because a rule that deletes something deletes it the same way twice.

mod common;

use common::judge::par_map;
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
            let Ok(output) = sclang_format::format_source(&input) else {
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

/// The tokens of `node`, in order: the leaves of the tree.
fn leaves<'a>(node: tree_sitter::Node<'a>, out: &mut Vec<tree_sitter::Node<'a>>) {
    if node.child_count() == 0 {
        out.push(node);
        return;
    }
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        leaves(child, out);
    }
}

/// A comment is never deleted, wherever it stands. Every form of
/// tests/lang11d/interpreted.forms and awkward.forms is taken once for each
/// gap between two of its tokens, with a comment put into that gap: a block
/// comment, and then a line comment with its line break. Where the grammar
/// still parses the text, the formatter must take it, must be done in one
/// pass, and must write the comment out again (and every other token).
#[test]
fn a_comment_between_any_two_tokens_is_kept() {
    let forms: Vec<String> = ["interpreted.forms", "awkward.forms"]
        .iter()
        .flat_map(|file| common::forms::forms(file))
        .map(|(_, form)| form)
        .collect();
    assert!(forms.len() > 500, "only {} forms were read", forms.len());

    // For each form: how many texts were tried, and what was wrong with any.
    let results = par_map(&forms, |form| {
        let mut parser = tree_sitter::Parser::new();
        parser
            .set_language(&sclang_format::grammar::language())
            .unwrap();
        let mut tried = 0usize;
        let mut faults = Vec::new();
        let tree = parser.parse(form, None).unwrap();
        if tree.root_node().has_error() {
            return (tried, faults);
        }
        let mut tokens = Vec::new();
        leaves(tree.root_node(), &mut tokens);
        for pair in tokens.windows(2) {
            // A gap is where one token ends, unless the next begins inside
            // it (a comment the form already has is a token like any other).
            let at = pair[0].end_byte();
            if pair[1].start_byte() < at {
                continue;
            }
            for comment in [" /*c*/ ", " // c\n"] {
                let text = format!("{}{comment}{}", &form[..at], &form[at..]);
                if parser.parse(&text, None).unwrap().root_node().has_error() {
                    continue;
                }
                tried += 1;
                let fault = match sclang_format::format_source(&text) {
                    Err(e) => format!("refused: {e:#}"),
                    Ok(once) => {
                        let changed = changed_tokens(&text, &once);
                        match sclang_format::format_source(&once) {
                            _ if !changed.is_empty() => {
                                format!("tokens changed ({}): {once:?}", changed.join(", "))
                            }
                            Ok(twice) if twice == once => continue,
                            Ok(twice) => format!("a second pass changes {once:?} to {twice:?}"),
                            Err(e) => format!("the formatter refuses its own {once:?}: {e:#}"),
                        }
                    }
                };
                faults.push(format!("{text:?}\n  {fault}"));
            }
        }
        (tried, faults)
    });
    let tried: usize = results.iter().map(|(tried, _)| tried).sum();
    let faults: Vec<String> = results.into_iter().flat_map(|(_, faults)| faults).collect();
    assert!(tried > 5000, "only {tried} texts with a comment were tried");
    assert!(
        faults.is_empty(),
        "{} of {tried} texts with a comment put between two tokens fail:\n\n{}",
        faults.len(),
        faults
            .iter()
            .take(60)
            .cloned()
            .collect::<Vec<_>>()
            .join("\n\n")
    );
}

/// A paragraph of comments that is filled again has more lines than it had,
/// and each begins with its slashes: the slashes that open a comment are not
/// counted. Every word of a comment still is, so a comment that is deleted,
/// or a word of one, is seen, wherever the comment stands. And a comment
/// that moves from the end of a line of code to a line of its own, as one
/// after `arg a;` does, is no change.
#[test]
fn a_comment_filled_again_keeps_its_tokens_and_one_cut_short_does_not() {
    let src = "// one two\n// three\nx = 1; // four\n";
    for kept in [
        "// one two three\nx = 1; // four\n",
        "    // one\n    // two\n    // three\nx = 1; // four\n",
        "// one two\n// three\nx = 1;\n// four\n",
    ] {
        assert_eq!(changed_tokens(src, kept), Vec::<String>::new());
    }
    for cut in [
        "// one two\nx = 1; // four\n",
        "// one\n// three\nx = 1; // four\n",
        "x = 1; // four\n",
        "// one two\n// three\nx = 1;\n",
        "// one two\n// three\nx = 1; //\n",
    ] {
        assert_ne!(changed_tokens(src, cut), Vec::<String>::new(), "{cut:?}");
    }
    // A slash that is no comment's is counted as it was.
    assert_ne!(
        changed_tokens("x = 1 / 2;", "x = 1 2;"),
        Vec::<String>::new()
    );
    assert_ne!(
        changed_tokens("/* a */ x", "/* a * x"),
        Vec::<String>::new()
    );
}
