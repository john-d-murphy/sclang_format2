// Source: Tutorials/Streams-Patterns-Events2.schelp block 4
(
var a, b;
a = Pgeom.new(10, 3, 8);	// stream starts at 10, steps by factor of 3 and has length 8
b = a.asStream;
9.do({ b.next.postln; });	// print 9 values from stream
)
