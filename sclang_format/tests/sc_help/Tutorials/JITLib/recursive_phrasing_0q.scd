// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 17/45)
(
	Pbind(
		\type, \phrase,
		\instrument, \sweep,
		\degree, 1,
		\legato, Pseq([0.5, 1, 2.3], inf),
		\recursionLevel, 3,
		\n, 3,
		\transparency, Pdup(8, Prand([0, 1, 2], inf))
	).play
)
