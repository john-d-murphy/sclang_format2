// Source: Classes/LFClipNoise.schelp block 0 (part 3/3)
(
SynthDef("help-LFClipNoise", { arg out=0;
	Out.ar(out,
		SinOsc.ar(
			LFClipNoise.ar(4, 200, 600),
			0, 0.2
		)
	)
}).play;
)
