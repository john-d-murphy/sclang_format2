// Source: Classes/Pwhite.schelp block 0 (part 4/5)
(
var a;
a = Pwhite(0.0, 1.0, inf).asStream;
{
	loop {
		Synth(\help_sinegrain, [\freq, a.next * 600 + 300]);
		0.02.wait;
	}
}.fork;
)
