// Source: Classes/Psetp.schelp block 0 (part 1/4)
(
var a, b;
a = Psetp(\freq, Pseq([801, 1008],inf), Pbind(\dur, Pseq([0.5, 0.111, 0.22])));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
