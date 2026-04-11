// Source: Classes/Punop.schelp block 0 (part 7/10)
(
var a;
a = Pn(Punop(\sqrt, Pseries(0, 1, 12))).asStream;
{
	a.do { |val|
		Synth(\help_sinegrain, [\freq, a * 200 + 300].postln);
		0.5.wait;
	}
}.fork;
)
