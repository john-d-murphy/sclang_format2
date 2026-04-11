// Source: Guides/Sync-Async.schelp block 0 (part 2/6)
(
SynthDef("Help-SynthDef", { arg out = 0;
	 Out.ar(out, PinkNoise.ar(0.1))
}).writeDefFile;
)
