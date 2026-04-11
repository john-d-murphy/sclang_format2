// Source: Classes/Pfinval.schelp block 0 (part 1/3)
(
var a, b;
a = Pfinval(5, Pseq(#[1, 2, 3],inf));
b = a.asStream;
9.do({ b.next.postln; });
)
