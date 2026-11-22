// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 18/45)
(
Pdef(\sweep, { arg dur=1, n=4, ratio=0.5, freq=440;
	var legato;
	freq = freq.value;
	legato = freq % 200 / 200 * 3 + 0.2;
	Pbind(
		\instrument, \pgrain,
		\dur, dur.value / n,
		\legato, legato,
		\freq, Pseq((1..n) * ratio + 1 * freq)
	)
});
)
