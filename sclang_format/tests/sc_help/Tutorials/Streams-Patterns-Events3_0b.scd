// Source: Tutorials/Streams-Patterns-Events3.schelp block 0 (part 2/2)
(
var a, b;
a = Pseq.new(#[1, 2, 3], 2);	// repeat twice
b = a.asStream;
7.do({ b.next.postln; });
)
