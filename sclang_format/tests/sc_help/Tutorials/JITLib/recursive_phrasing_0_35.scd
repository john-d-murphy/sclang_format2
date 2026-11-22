// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 36/45)
(
Pdef(\koch, { arg dur=1, freq=440;
	Pbind(
		\dur, dur.value / 3,
		\freq, freq.value * Pseq([1, 1.2, 1])
	)
});
)
