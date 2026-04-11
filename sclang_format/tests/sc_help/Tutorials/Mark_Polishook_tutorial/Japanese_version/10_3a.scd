// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/10.schelp block 3 (part 1/2)
(
SynthDef("passLowFreqs2", {
	Out.ar(
		0,
		RLPF.ar(
			Saw.ar([220, 221] + LFNoise0.kr(1, 100, 200), 0.2),
			[LFNoise0.kr(4, 600, 2400), LFNoise0.kr(3, 600, 2400)],
			0.1
		)
	)
}).add;
)
