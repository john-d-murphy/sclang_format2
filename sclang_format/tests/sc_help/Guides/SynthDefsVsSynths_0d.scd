// Source: Guides/SynthDefsVsSynths.schelp block 0 (part 4/10)
(
SynthDef("Help-SynthDef", { arg out = 0;
	Out.ar(out, PinkNoise.ar(0.1))
}).send(s);
)
