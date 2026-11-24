//! `sclang_format --units` prints the units of a file as one line of JSON:
//! what an editor compiles or evaluates by itself. It formats nothing.

use assert_cmd::cargo::cargo_bin_cmd;

fn units(src: &str) -> assert_cmd::assert::Assert {
    cargo_bin_cmd!("sclang_format")
        .arg("--units")
        .write_stdin(src)
        .assert()
}

#[test]
fn the_units_are_printed_as_one_line_of_json() {
    units("(\na;\n)\n\n(\nb;\n)\n").success().stdout(concat!(
        r#"[{"kind":"region","program":true,"start_byte":0,"end_byte":6,"start_line":1,"end_line":3},"#,
        r#"{"kind":"region","program":true,"start_byte":8,"end_byte":14,"start_line":5,"end_line":7}]"#,
        "\n"
    ));
    units("x = 1;\n").success().stdout(concat!(
        r#"[{"kind":"program","program":true,"start_byte":0,"end_byte":6,"start_line":1,"end_line":1}]"#,
        "\n"
    ));
}

#[test]
fn a_bracket_left_open_is_refused_with_its_line() {
    let refused = units("(\na;\n)\n\n(\nb;\n").failure().code(1);
    let stderr = String::from_utf8_lossy(&refused.get_output().stderr).to_string();
    assert!(stderr.contains("line 5"), "{stderr}");
}
