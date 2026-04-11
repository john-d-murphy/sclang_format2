// Source: Classes/FreeVerb2.schelp block 0 (part 3/7)
(
a = SynthDef(\src2x2, { |out|
	Out.ar(out,
		Decay.ar(Impulse.ar(1), 0.25, LFCub.ar(1200, 0, 0.1)) ! 2
		+
		Pan2.ar(
			Decay.ar(Impulse.ar(1, pi), 0.1, WhiteNoise.ar(0.1)),
			LFNoise1.kr(0.5).range(-1, 1)
		)
	)
}).play
)
