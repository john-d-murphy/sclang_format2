// Source: Classes/Padd.schelp block 0
(
var a, b;
a = Padd(\freq, 801, Pbind(\freq, 100));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
