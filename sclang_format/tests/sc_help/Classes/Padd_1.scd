// Source: Classes/Padd.schelp block 1
(
var a, b;
a = Padd(\freq, Pseq([401, 801], 2), Pbind(\freq, 100));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
