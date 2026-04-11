// Source: Guides/Sync-Async.schelp block 4
(
SynthDef("Help-SynthDef", { arg out = 0;
	Out.ar(out, PinkNoise.ar(0.1))
}).play(s);
)
