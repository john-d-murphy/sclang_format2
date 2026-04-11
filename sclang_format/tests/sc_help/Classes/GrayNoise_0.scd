// Source: Classes/GrayNoise.schelp block 0
(
SynthDef("help-GrayNoise", { arg out=0;
	Out.ar(out,
		GrayNoise.ar(0.1)
	)
}).play;
)
