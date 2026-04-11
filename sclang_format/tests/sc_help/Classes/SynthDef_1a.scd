// Source: Classes/SynthDef.schelp block 1 (part 1/3)
(
SynthDef(\help_isRand, { |out|
	Out.ar(out,
		SinOsc.ar(Rand(400, 800), 0, 0.2) * Line.kr(1, 0, 1, doneAction: Done.freeSelf)
	)
}).add;
)
