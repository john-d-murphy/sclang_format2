// Source: Tutorials/Streams-Patterns-Events2.schelp block 1
(
var a, b;
a = Pfunc.new({ #[1, 2, 3, 4].choose });
b = a.asStream;			// make a stream from the pattern
5.do({ b.next.postln; });	// print 5 values from the stream
)
