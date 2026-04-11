// Source: Classes/LocalBuf.schelp block 2 (part 3/11)
(
Pbind(
	\instrument, \fftgrain,
	\rate, Pwhite().linexp(0, 1, 0.01, 300),
	\legato, Pwhite(1, 3.0, inf),
	\dur, Prand([0.2, 1, 1.2], inf)
).play
)
