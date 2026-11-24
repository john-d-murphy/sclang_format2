// Source: Classes/LFClipNoise.schelp block 0 (part 2/3)
(
SynthDef("help-LFClipNoise", { |out = 0|
	Out.ar(out,
		LFClipNoise.ar(XLine.kr(1000, 10000, 10), 0.25)
	)
}).play;
)
