// Source: Tutorials/Streams-Patterns-Events3.schelp block 3
(
var a, b;
a = Pseq.new(#[1, 2, 3], inf);	// infinite repeat
b = a.asStream;
10.do({ b.next.postln; });
)
