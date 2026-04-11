// Source: Classes/Pmul.schelp block 1
(
var a, b;
a = Pmul(\freq, Pseq([3, 4, 6], 2), Pbind(\freq, 100));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
