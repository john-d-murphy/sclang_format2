// Source: Classes/Linen.schelp block 0 (part 8/8)
(
SynthDef("help-Linen",{ arg out = 0;
	Out.ar(out,

		Linen.kr(Impulse.kr(2),
			0.01,
			// sustain level is polled at time of trigger
			FSinOsc.kr(0.1).range(0, 1),
			1.0,
			doneAction: Done.none)

			* SinOsc.ar(440, 0, 0.1)
	)
}).play;
)
