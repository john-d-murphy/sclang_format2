// Source: Classes/Linen.schelp block 0 (part 1/8)
(
SynthDef("help-Linen",{ arg out = 0;
	Out.ar(out,
		Linen.kr(Impulse.kr(2), 0.01, 0.6, 1.0, doneAction: Done.none) * SinOsc.ar(440, 0, 0.1)
	)
}).play;
)
