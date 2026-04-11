// Source: Tutorials/Streams-Patterns-Events3.schelp block 10
(
var a, b;
a = Pshuf.new(#[1, 2, 3, 4], 3);
b = a.asStream;
13.do({ b.next.postln; });
)
