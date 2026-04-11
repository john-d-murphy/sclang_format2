// Source: Classes/Ppoisson.schelp block 0 (part 4/5)
(
var a;
a = Ppoisson(1.0,inf).asStream;
{
	loop {
		Synth(\help_sinegrain, [\freq, (a.next + 72).midicps]);
		0.02.wait;
	}
}.fork;
)
