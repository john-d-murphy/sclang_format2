// Source: Tutorials/Streams-Patterns-Events3.schelp block 5
(
var a, b;
a = Pser.new(#[1, 2, 3], 5);	// return 5 items
b = a.asStream;
6.do({ b.next.postln; });
)
