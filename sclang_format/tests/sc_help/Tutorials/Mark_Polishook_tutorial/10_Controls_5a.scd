// Source: Tutorials/Mark_Polishook_tutorial/10_Controls.schelp block 5 (part 1/3)
(
SynthDef("resetMyControls", { arg freq = 440, mul = 0.22;
	Out.ar(
		0,
		SinOsc.ar([freq, freq+1], 0, mul)
	)
}).add;
)
