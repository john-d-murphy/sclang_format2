// Source: Classes/Pmulpre.schelp block 0
(
var a, b;
a = Pmulpre(\note, 2, Pbind(\note, Pseq([1, 2, 3])));
x = a.asStream;
9.do({ x.next(Event.default).postln; });
)
