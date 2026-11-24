// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 29/45)
(
Pbind(
	\type, \phrase,
	\instrument, \sweep,
	\n, Prand([2, 4, 3, 8], inf),
	\degree, Pseq([-5, 0, -2], inf),
	\recursionLevel, Prand([0, 1],inf)
).play
)
