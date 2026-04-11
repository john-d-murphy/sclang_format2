// Source: Reference/randomSeed.schelp block 3 (part 1/7)
(
SynthDef(\help_randomSeed, { arg out=0, freq=440;
	Out.ar(out,
		Line.kr(1, 0, 0.3, doneAction: Done.freeSelf) *
		Resonz.ar(
			Dust2.ar([10, 10], 270) + WhiteNoise.ar(4),
		freq, 0.01)
	)
}).send(s);

SynthDef(\help_setRandomSeed, { arg seed=1956, tbus=0.0;
		RandSeed.kr(tbus, seed);
}).send(s);
)
