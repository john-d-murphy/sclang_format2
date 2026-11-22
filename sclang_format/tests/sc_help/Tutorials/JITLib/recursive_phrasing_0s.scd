// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 19/45)
(
	Pbind(
		\type, \phrase,
		\instrument, \sweep,
		\degree, Pseq((0..10),inf),
		\recursionLevel, 1
	).play
)
