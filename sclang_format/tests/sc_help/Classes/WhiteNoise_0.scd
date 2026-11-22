// Source: Classes/WhiteNoise.schelp block 0
(
SynthDef("help-WhiteNoise", { |out = 0|
	Out.ar(out,
		WhiteNoise.ar(0.25)
	)
}).play;
)
