// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 24/45)
(
Pbind(
	\type, \phrase,
	\instrument, \sweep,
	\n, Prand([2, 7, 3], inf),
	\degree, -5,
	\recursionLevel, Prand([0, 1, 2],inf)
).play
)
