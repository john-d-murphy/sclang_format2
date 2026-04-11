// Source: Guides/Multichannel-Expansion.schelp block 16 (part 2/2)
(
a = Pbind(
	\instrument, \help_multichannel,
	\freq, Pseq([[[342, 145]], [[187, 564]], [[234, 135]]], inf),
	\dur, 0.5
).play;
)
