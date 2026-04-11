// Source: Classes/ExpRand.schelp block 0 (part 1/2)
(
SynthDef("help-ExpRand", { arg out=0, n=0;
	Out.ar(out,
		FSinOsc.ar(
			ExpRand(100.0, 8000.0, n),
			0, Line.kr(0.2, 0, 0.01, doneAction: Done.freeSelf))
	)
}).add;
)
