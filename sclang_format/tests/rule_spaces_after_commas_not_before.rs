use sclang_format::format_source;
use pretty_assertions::assert_eq;

#[test]
fn comma_spacing_lists() {
    let input = "[1,2 ,3]";
    let expected = "[1, 2, 3]";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}

#[test]
fn comma_spacing_braces() {
    let input = "{ |a=1,b=2| a+b }";
    let expected = "{ |a = 1, b = 2| a + b }";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}
