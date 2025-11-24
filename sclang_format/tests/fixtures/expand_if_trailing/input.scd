(
// expand if trailing closures – single-line to multi-line

// short single-line trailing closures – should stay as-is
if (flag) { "short true".postln } { "short false".postln };

// long single-line: should be expanded into multi-line K&R style
if (reallyLongConditionNameThatKeepsGrowingAndGrowingBeyondReasonableWidth) { "this is a very long true branch message that will push us well over eighty characters".postln } { "this is a very long false branch message that also contributes to pushing the line beyond the configured width".postln };

// another long one, with semicolons in the bodies – still should expand
if (flag2) { "branch one with a reasonably long description to exceed the line width".postln; } { "branch two also with a verbose description to keep the whole statement long".postln; };

// already multi-line (from the previous rule) – should be ignored by the expander
if (flag3) {
    "already multi-line".postln
} {
    "also multi-line".postln
};
)

