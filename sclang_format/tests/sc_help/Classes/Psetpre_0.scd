// Source: Classes/Psetpre.schelp block 0
(
var a, b;
a = Psetpre(\freq, 801, Pbind(\dur, 0.5));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
