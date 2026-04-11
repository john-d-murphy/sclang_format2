// Source: Tutorials/Streams-Patterns-Events1.schelp block 8
(
var a, b;
// a is a stream that counts from 0 to 9
a = Routine.new({
		10.do({ arg i; i.yield; })
	});
// b is a stream that only returns the odd values from stream a
b = a.select({ arg item; item.odd; });
6.do({ b.next.postln; });
)
