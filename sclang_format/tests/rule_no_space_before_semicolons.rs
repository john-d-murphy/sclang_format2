use sclang_format::format_source;
use pretty_assertions::assert_eq;

#[test]
fn semicolon_spacing() {
    let input= "x = 3 + 5 ;\n\"wait ; don't\".postln;";
    let expected = "x = 3 + 5;\n\"wait ; don't\".postln;";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}
