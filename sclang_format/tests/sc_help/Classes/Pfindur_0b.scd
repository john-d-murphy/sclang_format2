// Source: Classes/Pfindur.schelp block 0 (part 2/4)
(
var a, b;
a = Pfindur(5, Pbind(\dur, Prand([1, 2, 0.5, 0.1], 4)));
x = a.asStream;
9.do({ x.next(Event.default).postln });
)
