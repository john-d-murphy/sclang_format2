// Source: Classes/IRand.schelp block 0 (part 1/2)
(
SynthDef("help-IRand", {
	Out.ar(
		IRand(0, 1), //play on random channel between 0 and 1
		FSinOsc.ar(500,
			0, Line.kr(0.2, 0, 0.1, doneAction: Done.freeSelf))
	)
}).add;
)
