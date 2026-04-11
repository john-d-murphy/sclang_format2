// Source: Classes/Pbinop.schelp block 1 (part 4/5)
(
var a;
a = Pn(Pseries(0, 1, 34) hypot: Pseries(3, -1, 34), inf).asStream;
{
	a.do { |val|
		Synth(\help_sinegrain, [\freq, a * 200 + 300].postln);
		0.05.wait;
	}
}.fork;
)
