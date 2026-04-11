// Source: Classes/Pexprand.schelp block 0 (part 3/3)
(
var a;
a = Pexprand(0.0001, 1.0,inf).asStream;
{
	loop {
		Synth(\help_sinegrain, [\freq, a.next * 600 + 300]);
		0.02.wait;
	}
}.fork;
)
