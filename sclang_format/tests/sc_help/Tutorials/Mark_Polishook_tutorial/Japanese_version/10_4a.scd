// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/10.schelp block 4 (part 1/2)
(
SynthDef("noiseToPitch", { arg out = 0, mul = 1;
	Out.ar(
		out,
		Resonz.ar(
			WhiteNoise.ar(mul),
			LFNoise0.kr(4, 110, 660),
			[0.005, 0.005]
		)
	)
}).add;
)
