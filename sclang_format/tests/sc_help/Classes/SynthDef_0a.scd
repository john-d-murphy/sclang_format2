// Source: Classes/SynthDef.schelp block 0 (part 1/3)
(
SynthDef(\help_notRand, { |out|
	Out.ar(out,
		SinOsc.ar(rrand(400, 800), 0, 0.2) * Line.kr(1, 0, 1, doneAction: Done.freeSelf)
	)
}).add;
)
