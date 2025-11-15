use sclang_format::format_source;

#[test]
fn no_space_before_semicolon() {
    let input = "x = 1 ; y = 2  ;";
    let expected = "x = 1; y = 2;";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}

#[test]
fn no_space_before_semicolon_newline_ok() {
    let input = "x = 1  ;\n";
    let expected = "x = 1;\n";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}
