// Source: Classes/LFClipNoise.schelp block 0 (part 1/3)
(
SynthDef("help-LFClipNoise", { |out = 0|
	Out.ar(out,
		LFClipNoise.ar(1000, 0.25)
	)
}).play;
)
