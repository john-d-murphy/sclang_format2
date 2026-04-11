// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/03.schelp block 1
(
SynthDef(
	"aSynthDef", 				// SynthDefの名前
	{ 					// ugenGraphFunc
		arg freq;
		Out.ar(
			0,
			SinOsc.ar(freq, 0, 0.1)
		)
	}
).load(s);
)
