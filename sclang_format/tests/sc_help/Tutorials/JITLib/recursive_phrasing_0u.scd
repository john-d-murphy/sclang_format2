// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 21/45)
(
Pbind(
	\type, \phrase,
	\instrument, \sweep,
	\degree, -5,
	\n, Pseq([1, 2, 3],inf),
	\recursionLevel, 3
).play
)
