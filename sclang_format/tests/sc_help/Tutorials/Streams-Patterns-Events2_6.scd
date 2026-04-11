// Source: Tutorials/Streams-Patterns-Events2.schelp block 6
(
var a, b, c;
a = Pseries.new(0,1,10);	// a is a pattern whose stream counts from 0 to 9
b = a + 100;			// add a constant value to pattern a
c = b.asStream;
12.do({ c.next.postln; });
)
