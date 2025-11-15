use sclang_format::format_source;

#[test]
fn assignment_basic() {
    let input = "x=1; y =2; z = 1+2;";
    let expected = "x = 1; y = 2; z = 1+2;";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}

#[test]
fn assignment_does_not_touch_comparisons() {
    let input = "a==b; c<=d; e>=f; g!=h;";
    let expected = "a==b; c<=d; e>=f; g!=h;";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}

#[test]
fn assignment_in_pipes() {
    let input = "~f={|freq=440 ,amp=0.1|SinOsc.ar(freq,amp)*amp};";
    let expected = "~f={|freq = 440, amp = 0.1|SinOsc.ar(freq, amp)*amp};";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}
