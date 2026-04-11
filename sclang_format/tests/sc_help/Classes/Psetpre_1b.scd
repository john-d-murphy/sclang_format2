// Source: Classes/Psetpre.schelp block 1 (part 2/4)
(
var a, b;
a = Psetpre(\freq, Pseq([401, 801], 2), Pbind(\dur, 0.5));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
