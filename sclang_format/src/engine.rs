use anyhow::{Context, Result, anyhow};
use std::fmt;
use tree_sitter::{Language, Node, Parser, Tree};

pub mod ast;
pub mod ast_utils;
pub mod layout;
pub mod text;

pub use ast::in_string_or_comment;

#[derive(Clone, Debug)]
pub struct TextEdit {
    pub start_byte: usize,
    pub end_byte: usize,
    pub replacement: String,
}

#[derive(Clone, Copy, Debug)]
pub enum IndentStyle {
    Tabs,
    Spaces { width: usize },
}

impl IndentStyle {
    /// The columns a level of indent takes. A tab is counted as the four
    /// that a level is when it is written in spaces and no width is asked for.
    #[must_use]
    pub const fn width(self) -> usize {
        match self {
            Self::Tabs => 4,
            Self::Spaces { width } => width,
        }
    }
}

pub struct Ctx {
    text: String,
    parser: Parser,
    pub tree: Tree,
    pub indent_style: IndentStyle,
    pub current_rule_name: Option<&'static str>,
    pub debug_edits: bool,
}

impl fmt::Display for Ctx {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(&self.text)
    }
}

pub fn print_ast_with_source(node: Node, source: &[u8], depth: usize) {
    let indent = "  ".repeat(depth);
    let start = node.start_byte();
    let end = node.end_byte();

    let snippet = if end > source.len() {
        "!!! OUT OF BOUNDS !!!".to_string()
    } else {
        let slice = &source[start..end];
        let s = String::from_utf8_lossy(slice);
        let clean = s.replace('\n', "\\n").replace('\r', "");
        if clean.len() > 50 {
            format!("{}...", &clean[..47])
        } else {
            clean
        }
    };

    println!(
        "{}{:<20} [{:>3}..{:<3}] {:?}",
        indent,
        node.kind(),
        start,
        end,
        snippet
    );

    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        print_ast_with_source(child, source, depth + 1);
    }
}

impl Ctx {
    /// The text, parsed.
    ///
    /// # Errors
    /// When the parser does not take the grammar, or gives no tree.
    pub fn new(src: String, lang: &Language, indent_style: IndentStyle) -> Result<Self> {
        let mut parser = Parser::new();
        parser.set_language(lang).context("set_language failed")?;
        let tree = parser.parse(src.as_str(), None).context("parse failed")?;

        Ok(Self {
            text: src,
            parser,
            tree,
            indent_style,
            current_rule_name: None,
            debug_edits: std::env::var("DEBUG_EDITS").is_ok(),
        })
    }

    #[must_use]
    pub const fn indent_style(&self) -> IndentStyle {
        self.indent_style
    }

    /// The text as it now stands. Borrowed, not copied: rules ask for it once
    /// a node, and a copy each time made the cost grow with the square of the file.
    #[must_use]
    pub const fn bytes(&self) -> &[u8] {
        self.text.as_bytes()
    }

    /// Makes the edits and parses the text again. Edits inside a string, a
    /// symbol or the words of a comment are dropped.
    ///
    /// # Errors
    /// When two edits overlap, or when the text does not parse after them:
    /// a rule has broken it.
    pub fn apply_edits(&mut self, mut edits: Vec<TextEdit>) -> Result<()> {
        if edits.is_empty() {
            return Ok(());
        }

        if self.debug_edits {
            let rule_name = self.current_rule_name.unwrap_or("unknown");
            eprintln!("\n=== {} edits ({}) ===", rule_name, edits.len());
            let bytes = self.bytes();

            for (i, edit) in edits.iter().enumerate() {
                let before_text = String::from_utf8_lossy(&bytes[edit.start_byte..edit.end_byte]);

                // Find the line containing this edit
                let mut line_start = edit.start_byte;
                while line_start > 0 && bytes[line_start - 1] != b'\n' {
                    line_start -= 1;
                }
                let mut line_end = edit.end_byte;
                while line_end < bytes.len() && bytes[line_end] != b'\n' {
                    line_end += 1;
                }
                let line_before = String::from_utf8_lossy(&bytes[line_start..line_end]);

                // Construct what the line will look like after this edit
                let mut line_after = String::new();
                line_after.push_str(&String::from_utf8_lossy(
                    &bytes[line_start..edit.start_byte],
                ));
                line_after.push_str(&edit.replacement);
                line_after.push_str(&String::from_utf8_lossy(&bytes[edit.end_byte..line_end]));

                eprintln!(
                    "Edit {}: [{}..{}] '{}' -> '{}'",
                    i, edit.start_byte, edit.end_byte, before_text, edit.replacement
                );
                eprintln!("  Before: '{line_before}'");
                eprintln!("  After:  '{line_after}'");
            }
        }

        // === CENTRALIZED EDIT PROTECTION ===
        // Drop any edits that are entirely INSIDE a comment or string node.
        // This prevents rules from modifying content within /* ... */, // ...,
        // or "..." regions.  Edits that SPAN across a protected range (like
        // compacting an array that contains strings) are allowed — they're
        // structural edits, not content modifications.
        let protected = collect_protected_ranges(self.tree.root_node(), self.bytes());
        if !protected.is_empty() {
            let before_count = edits.len();
            edits.retain(|e| {
                !protected.iter().any(|&(ps, pe)| {
                    // Edit is strictly inside a protected range
                    // (past the opening delimiter, before the closing one)
                    e.start_byte > ps && e.end_byte < pe
                })
            });
            let dropped = before_count - edits.len();
            if dropped > 0 && self.debug_edits {
                eprintln!("  Dropped {dropped} edits inside comments/strings");
            }
            if edits.is_empty() {
                return Ok(());
            }
        }

        edits.sort_by_key(|e| e.start_byte);
        // Two edits over the same bytes would each be applied to text the other
        // has already changed. Refuse them, rather than write whatever results.
        if let Some(pair) = edits.windows(2).find(|w| w[0].end_byte > w[1].start_byte) {
            return Err(anyhow!(
                "rule {} made overlapping edits at bytes {}..{} and {}..{}",
                self.current_rule_name.unwrap_or("unknown"),
                pair[0].start_byte,
                pair[0].end_byte,
                pair[1].start_byte,
                pair[1].end_byte
            ));
        }
        for e in edits.into_iter().rev() {
            self.text
                .replace_range(e.start_byte..e.end_byte, &e.replacement);
        }

        let source_string = &self.text;

        let new_tree = self
            .parser
            .parse(source_string, None)
            .context("reparse failed")?;

        // A rule that leaves text that does not parse has broken it. No
        // rule is given text that does not parse to begin with (parse_check
        // is the first), so there is nothing here to forgive.
        if new_tree.root_node().has_error() {
            eprintln!("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            eprintln!("FATAL: AST is broken after applying edits.");
            eprintln!("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");

            if let Some(name) = self.current_rule_name {
                eprintln!("Triggered by Rule: {name}\n");
            } else {
                eprintln!("Triggered by: Unknown Rule\n");
            }

            eprintln!("--- BROKEN TREE STRUCTURE (S-Expression) ---");
            eprintln!("{}", new_tree.root_node().to_sexp());
            eprintln!("--------------------------------------------\n");

            eprintln!("--- BROKEN SOURCE CODE ---");
            eprintln!("{source_string}");
            eprintln!("--------------------------\n");

            eprintln!("--- AST DUMP ---");
            print_ast_with_source(new_tree.root_node(), source_string.as_bytes(), 0);

            return Err(anyhow!(
                "Formatting resulted in invalid syntax (AST has errors). Bailing out."
            ));
        }

        self.tree = new_tree;
        Ok(())
    }

    #[must_use]
    pub fn slice_bytes(&self, start: usize, end: usize) -> String {
        self.text[start..end].to_string()
    }

    #[must_use]
    pub fn subtree_has_error(n: tree_sitter::Node) -> bool {
        if n.is_error() {
            return true;
        }
        let mut w = n.walk();
        for ch in n.children(&mut w) {
            if Self::subtree_has_error(ch) {
                return true;
            }
        }
        false
    }
}

/// Collect byte ranges of all comment and string nodes in the tree.
/// These are "no-touch" zones — edits strictly inside them are dropped.
fn collect_protected_ranges(root: Node, src: &[u8]) -> Vec<(usize, usize)> {
    let mut ranges = Vec::new();
    collect_protected_ranges_inner(root, src, &mut ranges);
    ranges
}

fn collect_protected_ranges_inner(node: Node, src: &[u8], ranges: &mut Vec<(usize, usize)>) {
    match node.kind() {
        "string" | "symbol" | "block_comment" => {
            ranges.push((node.start_byte(), node.end_byte()));
            return; // Don't recurse into protected nodes
        }
        "line_comment" => {
            // Protect the comment TEXT but not the `// ` prefix.
            // This allows inline_comment_spacing to normalize whitespace
            // after `//` while preventing any rule from changing the words.
            let start = node.start_byte();
            let end = node.end_byte();
            // Skip past `//` and any whitespace to find where text begins
            let mut text_start = start + 2; // past "//"
            while text_start < end && (src[text_start] == b' ' || src[text_start] == b'\t') {
                text_start += 1;
            }
            if text_start < end {
                ranges.push((text_start, end));
            }
            return;
        }
        _ => {}
    }
    let mut cursor = node.walk();
    for child in node.children(&mut cursor) {
        collect_protected_ranges_inner(child, src, ranges);
    }
}
