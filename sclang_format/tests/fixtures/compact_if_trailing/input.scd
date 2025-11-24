(
// compact if trailing closures – multi-line to single-line

// multi-line with short bodies – should compact
if (flag) {
    "short true".postln
} {
    "short false".postln
};

// already single-line – should remain unchanged
if (flag2) { "already short".postln } { "still short".postln };

// long condition/bodies – should *not* compact
if (reallyLongConditionNameThatKeepsGrowingAndGrowingBeyondReasonableWidth > 0) {
    "true branch with enough words to push us well over the eighty-character limit".postln
} {
    "false branch similarly verbose to ensure the collapsed form would be too wide".postln
};

// multi-line body – should not compact
if (flag3) {
    "line1".postln;
    "line2".postln;
} {
    "other".postln
};

// trailing semicolon should be preserved in compact form
if (flag4) {
    "short true with semicolon".postln;
} {
    "short false with semicolon".postln;
};
)

