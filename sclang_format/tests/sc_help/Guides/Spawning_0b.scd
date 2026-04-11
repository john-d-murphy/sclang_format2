// Source: Guides/Spawning.schelp block 0 (part 2/3)
(
SynthDef("help-Rand", { arg out = 0;
	Out.ar(
		out,
		FSinOsc.ar(
			Rand(200.0, 400.0), // frequency between 200 and 400 Hz
			0, Line.kr(0.2, 0, 1, doneAction: Done.freeSelf) // frees itself
		)
	)
}).play(s);
)
