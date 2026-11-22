// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 28/45)
(
e = Event.default;
e.use { ~sustain = { 2.0.exprand(0.05) } };
Pdef(\sweep, { arg sustain=1, n=8, degree=0, ratio=1;
	Pbind(
		\parent, e, // replace by some other event
		\instrument, \pgrain,
		\dur, sustain.value / n,
		\degree, Pseq((1..n)) * ratio + 1 + degree.value
	)
});
)
