// Source: Classes/FreeVerb.schelp block 0 (part 2/11)
(
z = SynthDef(\src, { |out, mix = 0.25, room = 0.15, damp = 0.5|
	Out.ar(out,
		FreeVerb.ar(
			Decay.ar(Impulse.ar(1), 0.25, LFCub.ar(1200, 0, 0.1)), // mono src
			mix, // mix 0-1
			room, // room 0-1
			damp // damp 0-1 duh
		) ! 2 // fan out...
	);
}).play
)
