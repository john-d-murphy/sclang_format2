// Source: Classes/SynthDef.schelp block 9 (part 13/13)
(
Pbind(
	\instrument, \synthDefTest,
	\freq, Pseq([500, 600, Prand([200, 456, 345], 1)], inf),
	\legato, Pseq([1.5, 0.2], inf),
	\dur, 0.4,
	\out, Pseq([0, 1], inf)
).play;
)
