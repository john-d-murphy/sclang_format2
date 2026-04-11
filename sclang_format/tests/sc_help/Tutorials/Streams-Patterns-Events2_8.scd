// Source: Tutorials/Streams-Patterns-Events2.schelp block 8
(
var a, b, c;
// a is a pattern whose stream counts from 0 to 9
a = Pseries.new(0,1,10);
// b is a pattern whose stream only returns the odd values
b = a.select({ arg item; item.odd; });
c = b.asStream;
6.do({ c.next.postln; });
)
