use crate::engine::Ctx;
use crate::rules::Rule;
use anyhow::{Result, bail};

/// Early bail-out if the source has parse errors.
/// This should be the first rule in the pipeline.
pub struct ParseCheck;

impl Rule for ParseCheck {
    fn name(&self) -> &'static str {
        "parse_check"
    }

    fn run(&self, cx: &mut Ctx) -> Result<usize> {
        if cx.tree.root_node().has_error() {
            bail!("parse error in source");
        }
        Ok(0)
    }
}
