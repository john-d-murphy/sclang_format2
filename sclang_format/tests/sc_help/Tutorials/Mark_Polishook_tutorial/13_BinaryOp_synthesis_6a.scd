// Source: Tutorials/Mark_Polishook_tutorial/13_BinaryOp_synthesis.schelp block 6 (part 1/2)
(
SynthDef("timeScale", { arg ts = 1;
	Out.ar(
		0,
		SinOsc.ar(440, 0, 0.4)
		*
		EnvGen.kr(
			Env.sine(1),
			doneAction: Done.freeSelf,
			timeScale: ts	// scale the duration of an envelope
		)
	)
}).add;
)
