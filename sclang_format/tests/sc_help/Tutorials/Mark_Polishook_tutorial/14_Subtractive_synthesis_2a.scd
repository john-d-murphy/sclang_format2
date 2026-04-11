// Source: Tutorials/Mark_Polishook_tutorial/14_Subtractive_synthesis.schelp block 2 (part 1/2)
(
SynthDef("passLowFreqs2", { arg out;
	Out.ar(
		out,
		RLPF.ar(
			Saw.ar([220, 221] + LFNoise0.kr(1, 100, 200), 0.2),
			[LFNoise0.kr(4, 600, 2400), LFNoise0.kr(3, 600, 2400)],
			0.1
		)
	)
}).add;
)
