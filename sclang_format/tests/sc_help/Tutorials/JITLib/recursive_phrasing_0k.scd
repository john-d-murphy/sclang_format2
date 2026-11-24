// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 11/45)
(
	Pbind(
		\type, \phrase,
		\instrument, \sweep,
		\degree, Pseq((0..5),inf),
		\legato, Pseq([1.2, 2.8, 0.3], inf)
	).play;
)
