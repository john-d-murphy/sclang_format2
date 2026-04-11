// Source: Tutorials/Streams-Patterns-Events3.schelp block 6
(
var a, b;
a = Prand.new(#[1, 2, 3, 4, 5], 6);	// return 6 items
b = a.asStream;
7.do({ b.next.postln; });
)
