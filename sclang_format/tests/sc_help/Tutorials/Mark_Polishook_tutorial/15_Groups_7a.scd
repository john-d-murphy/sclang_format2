// Source: Tutorials/Mark_Polishook_tutorial/15_Groups.schelp block 7 (part 1/3)
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
