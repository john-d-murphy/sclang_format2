// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 5/45)
(
Pdef(\sweep,
	Pbind(
		\instrument, Pseq([\pgrain, \noiseGrain],inf),
		\dur, Pseq([1, 2, 1, 3, 1, 4, 1, 5]) * 0.05,
		\legato, Prand([0.5, 0.5, 3],inf)
	)
)
)
