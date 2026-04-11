// Source: Classes/Paddp.schelp block 0
(
var a, b;
a = Paddp(\freq, Pseq([2, 3, pi],inf), Pbind(\freq, Pseq([100, 200, 300])));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
