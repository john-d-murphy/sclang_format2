use anyhow::{Context, Result};
use ropey::Rope;
use std::fmt;
use tree_sitter::{Language, Parser, Tree};

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
}

impl fmt::Display for Ctx {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        // Reuse the underlying Rope representation
        f.write_str(&self.rope.to_string())
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
        })
    }

    pub fn indent_style(&self) -> IndentStyle {
        self.indent_style
    }

    pub fn indent_unit(&self) -> String {
        match self.indent_style {
            IndentStyle::Tabs => "\t".to_string(),
            IndentStyle::Spaces { width } => " ".repeat(width),
        }
    }

    pub fn bytes(&self) -> Vec<u8> {
        self.rope.to_string().into_bytes()
    }

    pub fn apply_edits(&mut self, mut edits: Vec<TextEdit>) -> Result<()> {
        if edits.is_empty() {
            return Ok(());
        }
        edits.sort_by_key(|e| e.start_byte);
        for e in edits.into_iter().rev() {
            let start_char = self.rope.byte_to_char(e.start_byte);
            let end_char = self.rope.byte_to_char(e.end_byte);
            self.rope.remove(start_char..end_char);
            if !e.replacement.is_empty() {
                self.rope.insert(start_char, &e.replacement);
            }
        }
        self.tree = self
            .parser
            .parse(self.rope.to_string(), None)
            .context("reparse failed")?;
        Ok(())
    }

    pub fn slice_bytes(&self, start: usize, end: usize) -> String {
        self.rope.byte_slice(start..end).to_string()
    }

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
