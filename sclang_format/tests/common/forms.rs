//! The forms files of tests/lang11d, read.
//!
//! A line that begins `== ` is a heading: a
//! production, written as the Bison file writes it, or `lexer ...` for
//! something the lexer does. Headings that follow one another share what
//! comes under them. Under the headings come the forms, one to a paragraph,
//! or a line that begins `-- ` and says why no form can reach the
//! production. What stands before the first heading is the file's own
//! introduction.

use std::fs;
use std::path::PathBuf;

pub struct Group {
    pub headings: Vec<String>,
    pub forms: Vec<String>,
    /// Why no form reaches these productions, where none does.
    pub excuse: Option<String>,
}

pub fn groups(file: &str) -> Vec<Group> {
    let path = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
        .join("tests/lang11d")
        .join(file);
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
pub fn forms(file: &str) -> Vec<(String, String)> {
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
