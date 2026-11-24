// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 31/45)
(
Pbind(
	\type, \phrase,
	\instrument, \sweep,
	\n, { Pshuf([2, 4, 3, 8, 16, 32], inf) }, // use a function to insulate from embedInStream
	\degree, Pseq([-5, 0, -2], inf),
	\recursionLevel, Prand([0, 1],inf)
).play
)
