// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/06.schelp block 7 (part 1/3)
(
SynthDef("controlsWithLags", { arg freq = 440, mul = 0.22;
	Out.ar(
		0,
		SinOsc.ar([freq, freq+1], 0, mul)
	)
}, [1, 1]).add;
)
