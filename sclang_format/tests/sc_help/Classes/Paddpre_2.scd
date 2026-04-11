// Source: Classes/Paddpre.schelp block 2
(
var a, b;
a = Paddpre(\legato, Pseq([0.2, 0.4], 2), Pbind(\dur, 0.5));
x = a.asStream;
9.do({ x.next(Event.default).postln; });
)
