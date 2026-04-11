// Source: Classes/Pn.schelp block 0 (part 1/3)
(
var a, b;
a = Pn(Pseq(#[1, 2, 3], 1), 4);	// repeat pattern four times
b = a.asStream;
16.do({ b.next.postln; });
)
