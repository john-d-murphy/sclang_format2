use sclang_format::format_source;
use pretty_assertions::assert_eq;

#[test]
fn brace_and_pipes_singleline() {
    let input = "~f={|a=1,b=2|a+b};";
    let expected = "~f = { |a = 1, b = 2| a + b };";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}
