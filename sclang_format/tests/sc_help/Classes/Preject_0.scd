// Source: Classes/Preject.schelp block 0
(
var a, b;
a = Preject({ arg item; item == 1 }, Pseq(#[1, 2, 3],inf));
x = a.asStream;
9.do({ x.next.postln; });
)
