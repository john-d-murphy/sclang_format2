// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 12/45)
(
	Pbind(
		\type, \phrase,
		\instrument, \sweep,
		\transparency, 0,
		\degree, Pseq((0..5),inf),
		\legato, Pseq([1.2, 2.8, 0.3], inf)
	).play;
)
