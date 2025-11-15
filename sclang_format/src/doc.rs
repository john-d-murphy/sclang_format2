use std::fmt::Write;

/// Pretty-printing Doc IR
#[derive(Clone, Debug)]
pub enum Doc {
    Text(String),
    Space,    // " "
    SoftLine, // future: space or newline (for now renders as space)
    HardLine, // newline + indent
    Concat(Vec<Doc>),
    Indent(Box<Doc>),
    Group(Box<Doc>),
}

impl Doc {
    pub fn text<S: Into<String>>(s: S) -> Doc {
        Doc::Text(s.into())
    }
    pub fn space() -> Doc {
        Doc::Space
    }
    pub fn softline() -> Doc {
        Doc::SoftLine
    }
    pub fn line() -> Doc {
        Doc::HardLine
    }
    pub fn concat(parts: Vec<Doc>) -> Doc {
        Doc::Concat(parts)
    }
    pub fn indent(self) -> Doc {
        Doc::Indent(Box::new(self))
    }
    pub fn group(self) -> Doc {
        Doc::Group(Box::new(self))
    }
}

pub fn join(sep: Doc, mut parts: Vec<Doc>) -> Doc {
    use Doc::*;
    if parts.is_empty() {
        return Text(String::new());
    }
    let mut out = Vec::with_capacity(parts.len() * 2 - 1);
    let last = parts.pop().unwrap();
    for p in parts {
        out.push(p);
        out.push(sep.clone());
    }
    out.push(last);
    Concat(out)
}

#[derive(Clone, Copy, Debug)]
pub struct RenderConfig {
    pub width: usize,       // reserved for smarter wrapping later
    pub indent_size: usize, // spaces per indent level
}
impl Default for RenderConfig {
    fn default() -> Self {
        Self {
            width: 100,
            indent_size: 2,
        }
    }
}

pub fn render(doc: &Doc, cfg: &RenderConfig) -> String {
    let mut s = String::with_capacity(256);
    let mut st = State {
        out: &mut s,
        cfg,
        cur_indent: 0,
        at_line_start: true,
    };
    st.render(doc);
    s
}

struct State<'a> {
    out: &'a mut String,
    cfg: &'a RenderConfig,
    cur_indent: usize,
    at_line_start: bool,
}

impl<'a> State<'a> {
    fn render(&mut self, doc: &Doc) {
        use Doc::*;
        match doc {
            Text(t) => self.write(t),
            Space | SoftLine => self.write(" "),
            HardLine => self.newline(),
            Concat(v) => {
                for d in v {
                    self.render(d)
                }
            }
            Indent(d) | Group(d) => self.render(d),
        }
    }
    fn write(&mut self, s: &str) {
        if self.at_line_start {
            let pad = self.cfg.indent_size * self.cur_indent;
            let _ = write!(self.out, "{}", " ".repeat(pad));
            self.at_line_start = false;
        }
        let _ = write!(self.out, "{s}");
    }
    fn newline(&mut self) {
        let _ = writeln!(self.out);
        self.at_line_start = true;
    }
}

// tiny shorthands (optional)
pub mod d {
    use super::Doc;
    pub fn txt<S: Into<String>>(s: S) -> Doc {
        Doc::text(s)
    }
    pub fn sp() -> Doc {
        Doc::space()
    }
    pub fn sl() -> Doc {
        Doc::softline()
    }
    pub fn ln() -> Doc {
        Doc::line()
    }
    pub fn cat(v: Vec<Doc>) -> Doc {
        Doc::concat(v)
    }
}
