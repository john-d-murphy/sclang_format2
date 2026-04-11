// Source: Tutorials/Streams-Patterns-Events2.schelp block 2
(
var a, b, c;
a = Prout.new({
		3.do({ arg i; 3.rand.yield; })
	});
// make two streams from the pattern
b = a.asStream;
c = a.asStream;
4.do({ b.next.postln; });	// print 4 values from first stream
4.do({ c.next.postln; });	// print 4 values from second stream
)
