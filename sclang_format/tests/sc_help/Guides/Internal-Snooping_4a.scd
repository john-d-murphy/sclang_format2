// Source: Guides/Internal-Snooping.schelp block 4 (part 1/2)
(
f = SynthDef(\snoop, { | out=0 |
		Out.ar(out, PinkNoise.ar(0.1))
});
)
