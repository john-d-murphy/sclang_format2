// Source: Classes/Pconst.schelp block 0 (part 1/3)
(
var a, x;
a = Pconst(5, Prand([1, 2, 0.5, 0.1], inf));
x = a.asStream;
9.do({ x.next(Event.default).postln; });
)
