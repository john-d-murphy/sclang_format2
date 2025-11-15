use anyhow::*;
use tree_sitter::{Node, Tree};

use crate::doc::d as D;
use crate::doc::{Doc, RenderConfig, join, render};

pub struct Rewriter<'a> {
    pub src: &'a str,
    pub tree: &'a Tree,
}

impl<'a> Rewriter<'a> {
    pub fn new(src: &'a str, tree: &'a Tree) -> Self {
        Self { src, tree }
    }

    /// Format only pipe argument lists (`parameter_list`), leave everything else unchanged.
    pub fn format_only_pipe_args(&self) -> Result<String> {
        // collect replacements
        let mut reps: Vec<(usize, usize, String)> = Vec::new();
        let root = self.tree.root_node();
        let mut stack = vec![root];

        while let Some(n) = stack.pop() {
            let mut c = n.walk();
            for ch in n.children(&mut c) {
                stack.push(ch);
            }
            if n.kind() == "parameter_list" {
                let r = n.byte_range();
                let formatted = self.format_parameter_list(n)?;
                reps.push((r.start, r.end, formatted));
            }
        }

        if reps.is_empty() {
            return Ok(self.src.to_string());
        }

        // merge back into source
        reps.sort_by_key(|(s, _, _)| *s);
        let mut out = String::with_capacity(self.src.len());
        let mut cur = 0usize;
        for (start, end, repl) in reps {
            if start < cur {
                continue;
            } // overlapping safeguard
            out.push_str(&self.src[cur..start]);
            out.push_str(&repl);
            cur = end;
        }
        if cur < self.src.len() {
            out.push_str(&self.src[cur..]);
        }
        Ok(out)
    }

    fn format_parameter_list(&self, n: Node) -> Result<String> {
        if self.subtree_has_error(n) {
            let r = n.byte_range();
            return Ok(self.src[r.start..r.end].to_string());
        }

        // collect arguments as Docs
        let mut args_docs: Vec<Doc> = Vec::new();
        let mut c = n.walk();
        for ch in n.children(&mut c) {
            if ch.kind() == "argument" {
                args_docs.push(self.format_argument_doc(ch)?);
            }
        }

        // |a = 1, b, c = x|
        let sep = D::cat(vec![D::txt(","), Doc::space()]);
        let inner = join(sep, args_docs).group();
        let doc = D::cat(vec![D::txt("|"), inner, D::txt("|")]);

        let cfg = RenderConfig {
            width: 100,
            indent_size: 2,
        };
        Ok(render(&doc, &cfg))
    }

    fn format_argument_doc(&self, n: Node) -> Result<Doc> {
        let name = n
            .child_by_field_name("name")
            .ok_or_else(|| anyhow!("argument missing name"))?;
        let name_txt = self.slice(name).to_string();

        if let Some(val) = n.child_by_field_name("value") {
            let value_txt = self.slice(val).to_string(); // leave expression verbatim for now
            Ok(D::cat(vec![
                D::txt(name_txt),
                Doc::space(),
                D::txt("="),
                Doc::space(),
                D::txt(value_txt),
            ]))
        } else {
            Ok(D::txt(name_txt))
        }
    }

    fn slice(&self, n: Node) -> &str {
        let r = n.byte_range();
        &self.src[r.start..r.end]
    }

    fn subtree_has_error(&self, n: Node) -> bool {
        if n.is_error() {
            return true;
        }
        let mut c = n.walk();
        for ch in n.children(&mut c) {
            if self.subtree_has_error(ch) {
                return true;
            }
        }
        false
    }
}
