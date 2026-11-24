// Source: Classes/LFGauss.schelp block 4 (part 3/5)
(
Pdef(\x,
	Pbind(
		\instrument, \gabor,
		\freq, Pbrown(step: 0.01).linexp(0, 1, 100, 14000),
		\dur, Pbrown().linexp(0, 1, 0.004, 0.02),
		\legato, Pbrown(1, 3, 0.1, inf),
		\pan, Pwhite() * Pbrown()
	)
).play
)
