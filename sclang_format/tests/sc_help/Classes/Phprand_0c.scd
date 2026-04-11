// Source: Classes/Phprand.schelp block 0 (part 3/4)
(
var a;
a = Phprand(0.0, 1.0, inf).asStream;
{
	loop {
		Synth(\help_sinegrain, [\freq, a.next * 600 + 300]);
		0.02.wait;
	}
}.fork;
)
