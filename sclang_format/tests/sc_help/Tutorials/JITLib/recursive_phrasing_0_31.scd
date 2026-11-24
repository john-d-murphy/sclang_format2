// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 32/45)
(
Pdef(\sweep2, { arg sustain=1, n=2, degree=0, ratio=1;
	Pbind(
		\type, \phrase,
		\instrument, \sweep,
		\dur, sustain.value / n,
		\degree, Pseq((1..5).scramble * ratio + 1 + degree.value),
		\recursionLevel, 2
	)
});
)
