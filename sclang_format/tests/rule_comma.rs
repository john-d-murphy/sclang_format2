use sclang_format::format_source;
use pretty_assertions::assert_eq;

#[test]
fn commas_basic() {
    let input = "SinOsc.ar(freq,amp,phase).clip(0,1);";
    let expected = "SinOsc.ar(freq, amp, phase).clip(0, 1);";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}

#[test]
fn comma_no_space_before() {
    let input = "a , b ,c";
    let expected = "a, b, c";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}

#[test]
fn comma_before_closer_has_no_space() {
    let input = "foo(a,)";
    let expected = "foo(a,)";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}

#[test]
fn comma_before_newline_has_no_space() {
    let input = "foo(a,\n  b)";
    let expected = "foo(a,\n  b)";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}

