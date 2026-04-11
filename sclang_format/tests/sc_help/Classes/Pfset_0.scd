// Source: Classes/Pfset.schelp block 0
(
var a, b;
a = Pfset({
	~legato = 0.3;
	~detune = rrand(0, 30);
}, Pbind(\dur, 0.5));
x = a.asStream;
9.do({ x.next(Event.new).postln; });
)
