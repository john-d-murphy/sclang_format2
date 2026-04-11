// Source: Classes/Prand.schelp block 0 (part 1/4)
(
var a, b;
a = Prand([1, 2, 3, 4, 5], 6);	// return 6 items
b = a.asStream;
7.do({ b.next.postln; });
)
