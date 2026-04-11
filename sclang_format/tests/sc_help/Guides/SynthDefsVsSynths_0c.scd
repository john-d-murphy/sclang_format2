// Source: Guides/SynthDefsVsSynths.schelp block 0 (part 3/10)
(
SynthDef("Help-SynthDef", { arg out = 0;
	Out.ar(out, PinkNoise.ar(0.1))
}).load(s);
)
