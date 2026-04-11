// Source: Classes/Pwhite.schelp block 0 (part 5/5)
(
{
	loop {
		Synth(\help_sinegrain, [\freq, rrand(0.0, 1.0) * 600 + 300]);
		0.02.wait;
	}
}.fork;
)
