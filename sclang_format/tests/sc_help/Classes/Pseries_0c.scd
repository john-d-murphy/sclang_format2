// Source: Classes/Pseries.schelp block 0 (part 3/4)
(
var a;
a = Pseries(300, 20, 70).asStream;
{
	a.do { |val|
		Synth(\help_sinegrain, [\freq, val]);
		0.02.wait;
	}
}.fork;
)
