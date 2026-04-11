// Source: Classes/Pwrand.schelp block 0 (part 1/3)
(
var a, b;
a = Pwrand.new([1, 2, 3], [1, 3, 5].normalizeSum, 6);	// return 6 items
b = a.asStream;
7.do({ b.next.postln; });
)
