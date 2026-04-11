// Source: Reference/Syntax-Shortcuts.schelp block 0 (part 9/12)
collect ((1..10)) { arg n; n.squared }; // function call syntax with trailing-block argument
(1..10) collect: { arg n; n.squared };  // binary operator syntax


// partial application syntax

(1..10).collect(_.squared);
