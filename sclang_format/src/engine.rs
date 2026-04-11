use anyhow::{anyhow, Context, Result};
use ropey::Rope;
use std::fmt;
use tree_sitter::{Language, Node, Parser, Tree};

pub mod ast;
pub mod ast_utils;
pub mod layout;
pub mod scan;
pub mod width;

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

pub struct Ctx {
    rope: Rope,
    parser: Parser,
    pub tree: Tree,
    pub indent_style: IndentStyle,
    pub current_rule_name: Option<&'static str>,
    pub debug_edits: bool,
}

impl fmt::Display for Ctx {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(&self.rope.to_string())
    }
}

// --- STANDALONE HELPER FUNCTION ---
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
            clean.to_string()
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
    pub fn new(src: String, lang: Language, indent_style: IndentStyle) -> Result<Self> {
        let mut parser = Parser::new();
        parser.set_language(&lang).context("set_language failed")?;
        let tree = parser.parse(src.as_str(), None).context("parse failed")?;

        Ok(Self {
            rope: Rope::from_str(&src),
            parser,
            tree,
            indent_style,
            current_rule_name: None,
            debug_edits: std::env::var("DEBUG_EDITS").is_ok(), // ADD THIS
        })
    }

    #[must_use]
    pub const fn indent_style(&self) -> IndentStyle {
        self.indent_style
    }

    #[must_use]
    pub fn indent_unit(&self) -> String {
        match self.indent_style {
            IndentStyle::Tabs => "\t".to_string(),
            IndentStyle::Spaces { width } => " ".repeat(width),
        }
    }

    #[must_use]
    pub fn bytes(&self) -> Vec<u8> {
        self.rope.to_string().into_bytes()
    }

    pub fn apply_edits(&mut self, mut edits: Vec<TextEdit>) -> Result<()> {
        if edits.is_empty() {
            return Ok(());
        }

        // Track whether the tree already had errors before this edit batch.
        // If it did, we tolerate errors after — the semantic transform rules
        // (like PipeParamAddMissingCommas) need to run on broken trees to fix them.
        let had_errors_before = self.tree.root_node().has_error();

        // ADD THIS DEBUG BLOCK
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
                eprintln!("  Before: '{}'", line_before);
                eprintln!("  After:  '{}'", line_after);
            }
        }
        // END DEBUG BLOCK

        edits.sort_by_key(|e| e.start_byte);
        for e in edits.into_iter().rev() {
            let start_char = self.rope.byte_to_char(e.start_byte);
            let end_char = self.rope.byte_to_char(e.end_byte);
            self.rope.remove(start_char..end_char);
            if !e.replacement.is_empty() {
                self.rope.insert(start_char, &e.replacement);
            }
        }

        let source_string = self.rope.to_string(); // Capture this once for reuse below

        let new_tree = self
            .parser
            .parse(&source_string, None)
            .context("reparse failed")?;

        // === CRITICAL ERROR CHECK ===
        // Only bail if this rule INTRODUCED errors into a previously clean tree.
        // If the tree already had errors (e.g. missing commas in arg lists),
        // semantic transforms need to run to fix them.
        if new_tree.root_node().has_error() && !had_errors_before {
            eprintln!("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            eprintln!("FATAL: AST is broken after applying edits.");
            eprintln!("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");

            if let Some(name) = self.current_rule_name {
                eprintln!("Triggered by Rule: {}\n", name);
            } else {
                eprintln!("Triggered by: Unknown Rule\n");
            }

            eprintln!("--- BROKEN TREE STRUCTURE (S-Expression) ---");
            eprintln!("{}", new_tree.root_node().to_sexp());
            eprintln!("--------------------------------------------\n");

            eprintln!("--- BROKEN SOURCE CODE ---");
            eprintln!("{}", source_string);
            eprintln!("--------------------------\n");

            // FIX: Use the standalone function with the correct variables
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
        self.rope.byte_slice(start..end).to_string()
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
