// Source: Tutorials/Mark_Polishook_tutorial/10_Controls.schelp block 7 (part 1/3)
(
SynthDef("controlsWithLags", { arg freq1 = 440, freq2 = 443, mul = 0.12;
	Out.ar(
		0,
		SinOsc.ar([freq1, freq2], 0, mul)
	)
}, [4, 5]).add;
)
