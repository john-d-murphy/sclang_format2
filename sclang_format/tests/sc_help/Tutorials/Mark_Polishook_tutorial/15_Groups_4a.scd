// Source: Tutorials/Mark_Polishook_tutorial/15_Groups.schelp block 4 (part 1/3)
(
SynthDef("ringModulation", {
	Out.ar(
		0,
		Mix.ar(
			SinOsc.ar([440.067, 441.013], 0, 1)
			*
			SinOsc.ar([111, 109], 0, 0.2)
		)
	)
}).add;
)
