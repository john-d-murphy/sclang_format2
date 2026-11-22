// Source: Classes/FreeVerb.schelp block 0 (part 7/11)
(
z = SynthDef(\src, { |out, mix = 0.25, room = 0.15, damp = 0.5|
	Out.ar(out,
		FreeVerb.ar(
			Pan2.ar(
				Decay.ar(Impulse.ar(1), 0.25, LFCub.ar(1200, 0, 0.1)),
				LFNoise1.ar(1).range(-1, 1)
			),
			mix,
			room,
			damp
		)
	);
}).play
)
