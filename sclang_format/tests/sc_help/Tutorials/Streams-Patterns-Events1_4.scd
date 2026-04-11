// Source: Tutorials/Streams-Patterns-Events1.schelp block 4
(
var a, b;
// a is a stream that counts from 0 to 9
a = Routine.new({
		10.do({ arg i; i.yield; })
	});
b = a.squared;	// stream b is a square of the stream a
12.do({ b.next.postln; });
)
