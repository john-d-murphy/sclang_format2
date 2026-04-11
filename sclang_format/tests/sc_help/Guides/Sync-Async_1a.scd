// Source: Guides/Sync-Async.schelp block 1 (part 1/5)
(
SynthDef("Help-SynthDef", { arg out = 0;
	Out.ar(out, PinkNoise.ar(0.1))
}).send(s);
)
