// Source: Classes/Preject.schelp block 1
(
var a, b;
a = Pseq(#[1, 2, 3],inf).reject({ arg item; item == 1 });
a.postln;
x = a.asStream;
9.do({ x.next.postln; });
)
