// Source: Classes/PinkNoise.schelp block 0
(
SynthDef("help-PinkNoise", { arg out=0;
	Out.ar(out,
		PinkNoise.ar(0.4)
	)
}).play;
)
