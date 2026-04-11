// Source: Reference/Syntax-Shortcuts.schelp block 3 (part 1/4)
(
var f = { |n| (2**n) + (3**n) };
collect((1..5), f); // valid
(1..5).collect(f);  // valid
(1..5) collect: f;  // valid (selector as binary operator)
)
