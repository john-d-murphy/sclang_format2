// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/09.schelp block 8 (part 1/2)
(
SynthDef("timeScale", { arg ts = 1;
	Out.ar(
		0,
		SinOsc.ar(440, 0, 0.4) * EnvGen.kr(Env.sine(1), doneAction: Done.freeSelf, timeScale: ts)
	)
}).add;
)
