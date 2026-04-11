// Source: Tutorials/Mark_Polishook_tutorial/08_Rates.schelp block 2 (part 1/2)
(
SynthDef("anExample", {
	Out.ar(
		0,
		Pulse.ar(
			[220, 221.5] + SinOsc.kr([7, 8], 0, 7), // the control rate conserves CPU cycles
			0.35,
			0.02
		)
	)
}).add;
)
