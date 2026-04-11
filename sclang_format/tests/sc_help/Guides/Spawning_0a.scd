// Source: Guides/Spawning.schelp block 0 (part 1/3)
(
x = SynthDef("Help-SynthDef", { arg out = 0;
	Out.ar(out, PinkNoise.ar(0.1))
}).play; // SynthDef-play returns a Synth object.
)
