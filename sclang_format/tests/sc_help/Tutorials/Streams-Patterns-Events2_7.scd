// Source: Tutorials/Streams-Patterns-Events2.schelp block 7
(
var a, b, c;
// a is a pattern whose stream counts from 0 to 9
a = Pseries.new(0,1,10);
// b is a pattern whose stream adds 100 to even values
b = a.collect({ arg item; if (item.even, { item + 100 },{ item }); });
c = b.asStream;
6.do({ c.next.postln; });
)
