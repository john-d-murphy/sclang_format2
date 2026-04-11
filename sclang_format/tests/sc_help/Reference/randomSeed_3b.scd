// Source: Reference/randomSeed.schelp block 3 (part 2/7)
(
x = Synth(\help_setRandomSeed);
r = Routine({
	loop({
		Synth(\help_randomSeed, [\freq, rrand(440, 700)]);
		0.25.wait;
	})
}).play;
)
