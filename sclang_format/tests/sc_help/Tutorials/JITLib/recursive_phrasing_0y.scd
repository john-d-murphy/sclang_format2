// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 25/45)
(
Pdef(\sweep, { arg sustain=1, n=8, degree=0, ratio=1;
	Pbind(
		\instrument, \pgrain,
		\dur, sustain.value / n,
		\degree, Pseq((1..n)) * ratio + 1 + degree.value
	)
});
)
