// Source: Classes/Linen.schelp block 0 (part 3/8)
(
x = SynthDef("help-Linen",{ arg gate = 1, out = 0; // use gate arg for release
	Out.ar(out,
		Linen.kr(gate, 0.01, 0.6, 1.0, doneAction: Done.freeSelf) * SinOsc.ar(440, 0, 0.1)
	)
}).play;
)
