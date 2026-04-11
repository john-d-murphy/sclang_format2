// Source: Classes/Pbeta.schelp block 0 (part 6/7)
(
var a;
a = Pbeta(0.0, 1.0, 1.0, 1.0, inf).asStream;
{
	loop {
		Synth(\help_sinegrain, [\freq, a.next * 600 + 300]);
		0.02.wait;
	}
}.fork;
)
