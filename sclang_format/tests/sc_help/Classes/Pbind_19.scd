// Source: Classes/Pbind.schelp block 19
(
Pdef(\x,
	Pbind(
		\instrument, \test,
		\legato, 0.2,
		\degree, Ptuple([0, Pwalk(Scale.hijaz.degrees, Prand([1, -1], inf))]),
		\scale, Scale.hijaz,
		\strum, 0.05
	)
).play;
)
