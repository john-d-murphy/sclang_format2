// Source: Classes/Prand.schelp block 0 (part 2/4)
(
var a, b;
a = Prand([1, Pseq([10, 20, 30]), 2, 3, 4, 5], 6);	// return 6 items
b = a.asStream;
7.do({ b.next.postln; });
)
