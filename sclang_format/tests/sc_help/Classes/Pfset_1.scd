// Source: Classes/Pfset.schelp block 1
(
var a, b;
a = Pfset({
	~dur = 0.3;
}, Pbind(\dur, 0.5));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
