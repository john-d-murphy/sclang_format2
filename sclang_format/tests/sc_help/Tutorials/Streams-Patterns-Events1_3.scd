// Source: Tutorials/Streams-Patterns-Events1.schelp block 3
(
var a;
a = Routine.new({
		3.do({ arg i;
			(i+1).do({ arg j; j.yield; })
		})
	});
8.do({ a.next.postln; });	// print 8 values from stream
)
