// Source: Tutorials/Streams-Patterns-Events2.schelp block 3
(
var a, b;
a = Pseries.new(10, 3, 8);	// stream starts at 10, steps by 3 and has length 8
b = a.asStream;
9.do({ b.next.postln; });	// print 9 values from stream
)
