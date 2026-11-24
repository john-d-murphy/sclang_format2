// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 9/45)
(
Pdef(\sweep, { arg dur=1, n=4, freq=440, ratio=0.3;
	Pbind(
		\instrument, \pgrain,
		\dur, dur.value / n,	// now dur is dependant on outer dur.
		\freq, Pseries(1, 1, inf) * ratio + 1 * freq.value % 17000
	)
});
)
