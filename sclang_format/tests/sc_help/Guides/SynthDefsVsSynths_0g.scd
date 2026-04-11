// Source: Guides/SynthDefsVsSynths.schelp block 0 (part 7/10)
(
x = SynthDef("Help-SynthDef", { arg out = 0;
	Out.ar(out, PinkNoise.ar(0.1))
}).play(s);
)
