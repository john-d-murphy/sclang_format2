// Source: Tutorials/Mark_Polishook_tutorial/10_Controls.schelp block 1 (part 1/3)
(
// 3 arguments (controls) with default values
SynthDef(
	"withControls",
	{ arg freq = 440, beatFreq = 1, mul = 0.22;
	Out.ar(
		0,
		SinOsc.ar([freq, freq+beatFreq], 0, mul)
	)
}).add;
)
