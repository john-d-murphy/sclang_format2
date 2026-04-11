// Source: Tutorials/Streams-Patterns-Events1.schelp block 6
(
var a, b, c;
// a is a stream that counts from 0 to 9
a = Routine.new({
		10.do({ arg i; i.yield; })
	});
// b is a stream that counts from 100 to 280 by 20
b = Routine.new({
		forBy (100,280,20, { arg i; i.yield })
	});
c = a + b;	// add streams a and b
12.do({ c.next.postln; });
)
