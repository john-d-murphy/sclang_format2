// Source: Tutorials/Streams-Patterns-Events3.schelp block 2
(
var a, b;
a = Pseq.new(#[1, 2], { rrand(1, 3) });	// repeat 1,2, or 3 times
b = a.asStream;
7.do({ b.next.postln; });
)
