// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 13/45)
(
	Pbind(
		\type, \phrase,
		\instrument, \sweep,
		\degree, Pseq([0, 1, 2, 3], inf),
		\recursionLevel, 1
	).play
)
