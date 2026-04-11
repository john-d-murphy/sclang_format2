// Source: Classes/Pgauss.schelp block 0 (part 4/4)
(
var a;
a = Pgauss(0.0, 1.0,inf).asStream;
{
	loop {
		Synth(\help_sinegrain, [\freq, a.next * 600 + 300]);
		0.02.wait;
	}
}.fork;
)
