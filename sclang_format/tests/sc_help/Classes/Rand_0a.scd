// Source: Classes/Rand.schelp block 0 (part 1/2)
(
SynthDef("help-Rand", { arg out=0;
	Out.ar(out,
		FSinOsc.ar(
			Rand(200.0, 400.0),
			0, Line.kr(0.2, 0, 1, doneAction: Done.freeSelf))
	)
}).add;
)
