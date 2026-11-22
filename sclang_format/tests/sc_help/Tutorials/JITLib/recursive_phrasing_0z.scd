// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 26/45)
(
Pbind(
	\type, \phrase,
	\instrument, \sweep,
	\n, Prand([2, 4, 3, 8], inf),
	\degree, Pseq([-5, 0, -2], inf),
	\legato, Pseq([1.4, 0.5, 2], inf),
	\scale, #[0, 2, 5, 7, 10],
	\recursionLevel, Prand([0, 1, 2],inf)
).play
)
