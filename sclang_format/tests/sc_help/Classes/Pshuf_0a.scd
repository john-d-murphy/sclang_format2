// Source: Classes/Pshuf.schelp block 0 (part 1/3)
(
var a, b;
a = Pshuf([1, 2, 3, 4, 5], 3);	// repeat 3 times
b = a.asStream;
16.do({ b.next.postln; });
)
