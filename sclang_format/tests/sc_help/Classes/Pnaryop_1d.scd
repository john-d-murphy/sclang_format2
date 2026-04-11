// Source: Classes/Pnaryop.schelp block 1 (part 4/5)
(
var a;
a = Pseries(0, 1, 12).wrap(3, 7).asStream;
{
	a.do { |val|
		Synth(\help_sinegrain, [\freq, (val + 72) .midicps.postln]);
		0.5.wait;
	}
}.fork;
)
