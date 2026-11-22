// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 16/45)
(
	Pbind(
		\type, \phrase,
		\instrument, \sweep,
		\degree, 1,
		\legato, Pseq([0.5, 1, 1.3], inf),
		\recursionLevel, 3,
		\n, 3
	).play
)
