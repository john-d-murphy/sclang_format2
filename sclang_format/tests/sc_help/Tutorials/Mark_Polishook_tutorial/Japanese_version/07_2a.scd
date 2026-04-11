// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/07.schelp block 2 (part 1/2)
(
SynthDef("ringMod", {
	Out.ar(
		0,
		SinOsc.ar([440.067, 441.013], 0, 1) * SinOsc.ar([111, 109], 0, 0.2)
	)
}).add;
)
