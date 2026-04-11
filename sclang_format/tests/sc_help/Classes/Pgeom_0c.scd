// Source: Classes/Pgeom.schelp block 0 (part 3/4)
(
var a;
a = Pgeom(300, 1.03, 70).asStream;
{
	a.do { |val|
		Synth(\help_sinegrain, [\freq, val]);
		0.02.wait;
	}
}.fork;
)
