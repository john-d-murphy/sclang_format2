// Source: Classes/Pser.schelp block 0 (part 1/3)
(
var a, b;
a = Pser([1, 2, 3], 5);	// return 5 items
b = a.asStream;
6.do({ b.next.postln; });
)
