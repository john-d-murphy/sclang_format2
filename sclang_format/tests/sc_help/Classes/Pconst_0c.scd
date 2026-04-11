// Source: Classes/Pconst.schelp block 0 (part 3/3)
(
Pn(
	Pbind(
		\dur, Pconst(1, Prand([1, 0.02, 0.2], inf)),
		\instrument, \help_sinegrain,
		\degree, Pseries(0, 1, inf),
		\octave, 6
	)
).play;
)
