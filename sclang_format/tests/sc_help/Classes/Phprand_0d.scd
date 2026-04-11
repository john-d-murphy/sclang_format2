// Source: Classes/Phprand.schelp block 0 (part 4/4)
(
{
	loop {
		Synth(\help_sinegrain, [\freq, max(rrand(0.0, 1.0), rrand(0.0, 1.0)) * 600 + 300]);
		0.02.wait;
	}
}.fork;
)
