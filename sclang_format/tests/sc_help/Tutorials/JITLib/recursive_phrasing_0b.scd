// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 2/45)
(
Pbind(
	\type, \phrase, // phrase event from global library
	\instrument, \sweep,
	\n, 15,
	\degree, Pseq([0, 4, 6, 3], inf),
	\sustain, Pseq([1.3, 0.2, 0.4],inf)
).play
)
