// Source: Classes/Pbinop.schelp block 1 (part 2/5)
(
var a;
a = Pn(Pbinop(\hypot, Pseries(0, 1, 34), Pseries(3, -1, 34)), inf).asStream;
{
	a.do { |val|
		Synth(\help_sinegrain, [\freq, a * 200 + 300].postln);
		0.05.wait;
	}
}.fork;
)
