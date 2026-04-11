// Source: Guides/Spawning.schelp block 7 (part 2/3)
(
// this Synth will send a trigger to the client app
SynthDef("help-SendTrig", {
	SendTrig.kr(
		Dust.kr(1.0), // trigger could be anything, e.g. Amplitude.kr(SoundIn.ar(0) > 0.5)
		0, 0.9
	);
}).send(s);
)
