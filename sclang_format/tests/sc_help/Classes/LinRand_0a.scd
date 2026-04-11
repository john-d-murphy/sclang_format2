// Source: Classes/LinRand.schelp block 0 (part 1/3)
(
SynthDef("help-LinRand", { arg out=0, minmax=1;
	Out.ar(out,
		FSinOsc.ar(
			LinRand(200.0, 10000.0, minmax),
			0, Line.kr(0.2, 0, 0.01, doneAction: Done.freeSelf))
	)
}).add;
)
