// Source: Tutorials/Streams-Patterns-Events1.schelp block 5
(
var a, b;
// a is a stream that counts from 0 to 9
a = Routine.new({
		10.do({ arg i; i.yield; })
	});
b = a + 100;	// add a constant value to stream a
12.do({ b.next.postln; });
)
