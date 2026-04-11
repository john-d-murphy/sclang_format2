// Source: Classes/Pselect.schelp block 1
(
var a, b;
a = Pseq(#[1, 2, 3],inf).select({ arg item; item != 2 });
a.postln;
x = a.asStream;
9.do({ x.next.postln; });
)
