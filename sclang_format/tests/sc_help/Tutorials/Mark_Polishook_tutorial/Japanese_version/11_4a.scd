// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/11.schelp block 4 (part 1/2)
(
SynthDef("firstNode-source", {
	Out.ar(
		0,
		Saw.ar([200, 201], 0.05)
	)
}).add;

SynthDef("secondNode-filter", {
	ReplaceOut.ar(
		0,
		LPF.ar(
			In.ar(0, 2),
			Lag.kr(
				LFNoise0.kr([4, 4.001], 500, 1000),
				0.1
			)
		)
	)
}).add;
)
