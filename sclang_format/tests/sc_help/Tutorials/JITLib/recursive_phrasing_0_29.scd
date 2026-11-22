// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 30/45)
(
Pdef(\sweep, { arg sustain=1, n=8, degree=0, ratio=1;
	n = n.value;
	Pbind(
		\instrument, \pgrain,
		\dur, sustain.value / n,
		\degree, Pseq([ 1, 2, 3, 4, 5 ] * ratio + 1 + degree.value) )
});
)
