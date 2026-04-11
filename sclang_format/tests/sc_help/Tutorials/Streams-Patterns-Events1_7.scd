// Source: Tutorials/Streams-Patterns-Events1.schelp block 7
(
var a, b;
// a is a stream that counts from 0 to 9
a = Routine.new({
		10.do({ arg i; i.yield; })
	});
// b is a stream that adds 100 to even values
b = a.collect({ arg item; if (item.even, { item + 100 },{ item }); });
6.do({ b.next.postln; });
)
