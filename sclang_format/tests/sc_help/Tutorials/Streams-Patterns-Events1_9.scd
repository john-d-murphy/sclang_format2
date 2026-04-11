// Source: Tutorials/Streams-Patterns-Events1.schelp block 9
(
var a, b;
// a is a stream that counts from 0 to 9
a = Routine.new({
		10.do({ arg i; i.yield; })
	});
// b is a stream that only returns the non-odd values from stream a
b = a.reject({ arg item; item.odd; });
6.do({ b.next.postln; });
)
