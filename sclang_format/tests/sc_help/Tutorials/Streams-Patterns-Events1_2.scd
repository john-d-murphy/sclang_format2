// Source: Tutorials/Streams-Patterns-Events1.schelp block 2
(
var a;
a = Routine.new({
		3.do({ arg i; i.yield; })
	});
4.do({ a.next.postln; });	// print 4 values from stream
)
