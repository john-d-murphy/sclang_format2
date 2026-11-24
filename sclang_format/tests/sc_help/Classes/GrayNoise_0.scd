// Source: Classes/GrayNoise.schelp block 0
(
SynthDef("help-GrayNoise", { |out = 0|
	Out.ar(out,
		GrayNoise.ar(-20.dbamp)
	)
}).play;
)
