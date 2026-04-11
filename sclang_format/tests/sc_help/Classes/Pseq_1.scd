// Source: Classes/Pseq.schelp block 1
(
var a, b;
a = Pseq([1, 2, 3, 4], 3, 2);	// repeat 3, offset 2
b = a.asStream;
13.do({ b.next.postln; });
)
