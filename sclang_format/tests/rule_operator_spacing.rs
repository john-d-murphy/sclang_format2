use sclang_format::format_source;
use pretty_assertions::assert_eq;

#[test]
fn operator_spacing_basic() {
    let input = "x=1+2*3; y = -4+5;";
    let expected = "x = 1 + 2 * 3; y = -4 + 5;";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}
