// Source: Classes/Score.schelp block 4 (part 2/8)
(
SynthDef("helpscore", { |out, freq = 440|
	Out.ar(out,
		SinOsc.ar(freq, 0, 0.2) * Line.kr(1, 0, 0.5, doneAction: Done.freeSelf)
	)
}).store;
)
