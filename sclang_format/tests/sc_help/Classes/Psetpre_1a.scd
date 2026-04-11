// Source: Classes/Psetpre.schelp block 1 (part 1/4)
(
var a, b;
a = Psetpre(\freq, 801, Pbind(\freq, 108));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
