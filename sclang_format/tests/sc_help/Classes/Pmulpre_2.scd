// Source: Classes/Pmulpre.schelp block 2
(
var a, b;
a = Pmulpre(\freq, Pseq([401, 801], 2), Pbind(\dur, 0.5));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
