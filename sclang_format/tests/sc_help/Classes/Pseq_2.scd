// Source: Classes/Pseq.schelp block 2
(
var a, b;
a = Pseq([1, 2], { rrand(1, 3) });	// repeat 1,2, or 3 times
b = a.asStream;
7.do({ b.next.postln; });
)
