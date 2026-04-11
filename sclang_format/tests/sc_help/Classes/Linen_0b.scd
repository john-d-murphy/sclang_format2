// Source: Classes/Linen.schelp block 0 (part 2/8)
(
SynthDef("help-Linen",{ arg out=0;
	Out.ar(out,
		Linen.kr(Impulse.kr(0), 0.01, 0.6, 1.0, doneAction: Done.freeSelf) * SinOsc.ar(440, 0, 0.1)
	)
}).play;
)
