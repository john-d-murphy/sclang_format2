// Source: Tutorials/Streams-Patterns-Events3.schelp block 12
(
var a, b;
a = Pseq.new([1, Pseq.new([100,200], 2), 3], 3);
b = a.asStream;
19.do({ b.next.postln; });
)
