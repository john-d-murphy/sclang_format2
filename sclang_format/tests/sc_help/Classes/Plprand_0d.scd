// Source: Classes/Plprand.schelp block 0 (part 4/4)
(
{
	loop {
		Synth(\help_sinegrain, [\freq, min(rrand(0.0, 1.0), rrand(0.0, 1.0)) * 600 + 300]);
		0.02.wait;
	}
}.fork;
)
