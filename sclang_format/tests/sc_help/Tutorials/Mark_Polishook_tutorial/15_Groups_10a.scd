// Source: Tutorials/Mark_Polishook_tutorial/15_Groups.schelp block 10 (part 1/3)
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
