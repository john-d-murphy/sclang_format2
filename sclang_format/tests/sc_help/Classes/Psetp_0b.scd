// Source: Classes/Psetp.schelp block 0 (part 2/4)
(
var a, b;
a = Psetp(\freq, 801, Pbind(\freq, 108));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
