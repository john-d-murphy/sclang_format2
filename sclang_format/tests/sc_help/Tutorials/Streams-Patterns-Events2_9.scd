// Source: Tutorials/Streams-Patterns-Events2.schelp block 9
(
var a, b, c;
// a is a pattern whose stream counts from 0 to 9
a = Pseries.new(0,1,10);
// b is a pattern whose stream that only returns the non-odd values
b = a.reject({ arg item; item.odd; });
c = b.asStream;
6.do({ c.next.postln; });
)
