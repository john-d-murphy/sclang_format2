// Source: Classes/Punop.schelp block 0 (part 9/10)
(
var a;
a = Pn(Pseries(0, 1, 12).sqrt).asStream;
{
	a.do { |val|
		Synth(\help_sinegrain, [\freq, a * 200 + 300].postln);
		0.05.wait;
	}
}.fork;
)
