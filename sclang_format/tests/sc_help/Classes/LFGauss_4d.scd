// Source: Classes/LFGauss.schelp block 4 (part 4/5)
(
Pdef(\x,
	Pbind(
		\instrument, \gabor,
		\freq, 1000,
		\dur, 0.01,
		\width, Pseg(Pseq([0.25, 0.002], inf), 10, \exp),
		\legato, 2
	)
).play
)
