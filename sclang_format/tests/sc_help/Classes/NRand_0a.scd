// Source: Classes/NRand.schelp block 0 (part 1/5)
(
SynthDef("help-NRand", { arg out=0, n=0;
	Out.ar(out,
		FSinOsc.ar(
			NRand(1200.0, 4000.0, n),
			0, Line.kr(0.2, 0, 0.01, doneAction: Done.freeSelf))
	)
}).add;
)
