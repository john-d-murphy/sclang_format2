// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 8/45)
(
Pbind(
	\type, \phrase,
	\instrument, \sweep,
	\degree, Pseq([0, 1b, 4, 2, 3, 1b], inf),
	\pan, Pfunc(#{ 1.0.rand2 })
).play
)
