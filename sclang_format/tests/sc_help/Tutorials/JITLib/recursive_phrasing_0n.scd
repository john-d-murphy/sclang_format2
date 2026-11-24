// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 14/45)
(
	Pbind(
		\type, \phrase,
		\instrument, \sweep,
		\degree, Pseq([0, 1, 2, 3], inf),
		\legato, Pseq([0.5, 1, 1.5, 1.8], inf),
		\recursionLevel, 1
	).play
)
