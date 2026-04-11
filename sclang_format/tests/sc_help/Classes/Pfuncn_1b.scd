// Source: Classes/Pfuncn.schelp block 1 (part 2/2)
(
var a, b, c;
a = Pfuncn({ exprand(0.1, 2.0) + #[1, 2, 3, 6].choose }, 2);
b = Pfuncn({ #[-2, -3].choose }, 7);
c = Pseq([a, b], inf).asStream;
{
	c.do { |val|
		Synth(\help_sinegrain, [\freq, val * 100 + 300]);
		0.02.wait;
	}
}.fork;
)
