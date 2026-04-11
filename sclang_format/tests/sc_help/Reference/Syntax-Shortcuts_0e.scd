// Source: Reference/Syntax-Shortcuts.schelp block 0 (part 5/12)
collect ((1..10)) { |n| n.squared }; // function call syntax with trailing-block argument
(1..10) collect: { |n| n.squared };  // binary operator syntax


// old argument syntax

(1..10).collect({ arg n; n.squared });
