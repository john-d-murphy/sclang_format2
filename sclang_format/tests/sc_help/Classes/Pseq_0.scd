// Source: Classes/Pseq.schelp block 0
(
var a, b;
a = Pseq([1, 2, 3], 2);	// repeat twice
b = a.asStream;
7.do({ b.next.postln; });
)
