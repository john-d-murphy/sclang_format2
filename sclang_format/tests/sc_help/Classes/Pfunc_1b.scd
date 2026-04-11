// Source: Classes/Pfunc.schelp block 1 (part 2/2)
(
var a;
a = Pfunc({ exprand(0.1, 0.3) + #[1, 2, 3, 6, 7].choose }).asStream;
{
	a.do { |val|
		Synth(\help_sinegrain, [\freq, val * 100 + 300]);
		0.02.wait;
	}
}.fork;
)
