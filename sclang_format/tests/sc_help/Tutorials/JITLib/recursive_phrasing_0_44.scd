// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 45/45)
(
Pbind(
	\type, \phrase,
	\instrument, \poch,
	\recursionLevel, Prand([0, 1, 2, 3], inf),
	\from, 0,
	\to, Prand([-1, 1], inf),
	\dur, 3,
	\n, Prand([1, 2, 3], inf),
	\bufnum, b,
	\amp, 0.2
).play
)
