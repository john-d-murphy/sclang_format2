// Source: Classes/Rest.schelp block 5
(
Pbind(
	\degree, Pif(
		0.1.loop.coin,
		Pseq([Rest(), 7], inf), // every second is a Rest
		Pseries(0, 1, inf).fold(-7, 7)
	),
	\dur, 0.125
).play
)
