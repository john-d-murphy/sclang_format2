// Source: Tutorials/Streams-Patterns-Events1.schelp block 1
(
var a;
a = FuncStream.new({ #[1, 2, 3, 4].choose });
5.do({ a.next.postln; });	// print 5 values from the stream
)
