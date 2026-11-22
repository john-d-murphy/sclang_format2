// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 3/45)
(
Pbind(
	\type, \phrase, // phrase event from global library
	\instrument, \sweep,
	\n, 15,
	\degree, Pseq([0, 0, 6, 3], inf) + Prand([0, [0, 3], [0, 5], [0, 15]], inf),
	\ratio, Prand([ 0.1, 0.1, [0.1, -0.1] ], inf)
).play
)
