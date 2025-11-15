use sclang_format::format_source;
use pretty_assertions::assert_eq;

#[test]
fn dot_spacing() {
    let input = "Button()  .  states_([1,2])  .  action_({\"x\".postln});";
    let expected = "Button().states_([1, 2]).action_({ \"x\".postln });";
    let out = format_source(input, "inline").unwrap();
    assert_eq!(out, expected);
}

