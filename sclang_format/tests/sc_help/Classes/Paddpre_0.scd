// Source: Classes/Paddpre.schelp block 0
(
var a, b;
a = Paddpre(\x, 8, Pbind(\dur, 0.5));
x = a.asStream;
9.do({ x.next((\x:4)).postln; });
)
