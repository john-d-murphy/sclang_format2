// Source: Classes/Pfin.schelp block 0 (part 1/5)
(
var a, b;
a = Pfin(5, Pseq(#[1, 2, 3],inf));
b = a.asStream;
9.do({ b.next.postln; });
)
