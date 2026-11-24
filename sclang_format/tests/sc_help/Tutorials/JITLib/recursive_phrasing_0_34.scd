// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 35/45)
(
Pdef(\sweep,
	Pbind(
		\instrument, \pgrain,
		\dur, exprand(0.01, 0.1),
		\legato, rrand(0.01, 2.0),
		\octave, rrand(5, 7)
	)
)
)
