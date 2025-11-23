use glob::glob;
use pretty_assertions::assert_eq; // handy for non-snapshot checks
mod common;

#[test]
fn format_fixtures_to_snapshots() {
    for entry in glob("tests/fixtures/**/input.scd").unwrap() {
        let input_path = entry.unwrap();
        let input = std::fs::read_to_string(&input_path).unwrap();
        let out = common::run_cli_on_str(&input).unwrap();

        // Build a stable snapshot name from the relative path, e.g.
        // tests/fixtures/assignment_in_pipes/input.scd
        //  -> assignment_in_pipes__inline
        let rel = input_path.strip_prefix("tests/fixtures").unwrap();
        let stem = rel.parent().unwrap().to_string_lossy().replace('/', "__");
        let name = format!("{}__inline", stem);

        // Keep metadata: where did this output come from?
        insta::with_settings!({
            // snapshots/ folder will sit next to this test file by default; leave as is
            // add a suffix if you later snapshot multiple modes (inline, block, etc.)
            snapshot_suffix => "out",
            input_file => rel,    // stored as metadata in .snap
        }, {
            insta::assert_snapshot!(name, out);
        });
    }
}

#[test]
fn formatter_is_idempotent() {
    // Re-run the formatter on its own output; the result must not change.
    for entry in glob("tests/fixtures/**/input.scd").unwrap() {
        let input = std::fs::read_to_string(entry.unwrap()).unwrap();
        let once = common::run_cli_on_str(&input).unwrap();
        let twice = common::run_cli_on_str(&once).unwrap();
        assert_eq!(twice, once, "formatter must be idempotent");
    }
}
