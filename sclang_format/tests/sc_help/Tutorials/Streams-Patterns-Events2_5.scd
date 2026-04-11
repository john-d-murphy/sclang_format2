// Source: Tutorials/Streams-Patterns-Events2.schelp block 5
(
var a, b, c;
a = Pseries.new(0,1,10);	// a is a pattern whose stream counts from 0 to 9
b = a.squared;			// pattern b is a square of the pattern a
c = b.asStream;
12.do({ c.next.postln; });
)
