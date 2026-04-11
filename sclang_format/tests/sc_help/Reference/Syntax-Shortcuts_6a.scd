// Source: Reference/Syntax-Shortcuts.schelp block 6 (part 1/4)
(
var a = (_+_) ! [3, 3]; // -> [ [ 0, 1, 2 ], [ 1, 2, 3 ], [ 2, 3, 4 ] ]
(0..2) collect: (+++)(a, 99, _) flatten: 3; // iterated adverb
)
