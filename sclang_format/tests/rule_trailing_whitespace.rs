use sclang_format::format_source;
use pretty_assertions::assert_eq;

#[test]
fn trailing_ws_and_eof_newline() {
    let input = "x = 3;   \n";
    let expected = "x = 3;\n";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}
