// Source: Classes/Pselect.schelp block 0
(
var a, b;
a = Pselect({ arg item; item != 2 }, Pseq(#[1, 2, 3],inf));
x = a.asStream;
9.do({ x.next.postln; });
)
