// Source: Tutorials/Streams-Patterns-Events3.schelp block 13
(
var a, b;
a = Prand.new([
		Pseq.new([1, 2], 2),
		Pseq.new([3, 4], 2),
		Pseq.new([5, 6], 2)
	], 3);
b = a.asStream;
13.do({ b.next.postln; });
)
