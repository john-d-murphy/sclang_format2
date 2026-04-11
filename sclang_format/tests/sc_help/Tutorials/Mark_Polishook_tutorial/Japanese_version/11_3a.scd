// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/11.schelp block 3 (part 1/2)
(
SynthDef("pitchFromNoise", { arg out = 0;
	Out.ar(
		out,
		Resonz.ar(
			WhiteNoise.ar(15),
			LFNoise0.kr(2, 110, 660),
			0.005
		)
	)
}).add;
)
