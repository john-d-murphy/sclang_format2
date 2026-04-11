// Source: Tutorials/Streams-Patterns-Events3.schelp block 8
(
var a, b;
a = Pxrand.new(#[1, 2, 3], 10);	// return 10 items
b = a.asStream;
11.do({ b.next.postln; });
)
