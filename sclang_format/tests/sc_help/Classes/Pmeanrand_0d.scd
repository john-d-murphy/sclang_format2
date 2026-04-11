// Source: Classes/Pmeanrand.schelp block 0 (part 4/4)
(
{
	loop {
		Synth(\help_sinegrain, [\freq, (rrand(0.0, 1.0) + rrand(0.0, 1.0) * 0.5) * 600 + 300]);
		0.02.wait;
	}
}.fork;
)
