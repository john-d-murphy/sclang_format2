// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 42/45)
(
Pdef(\poch, { arg sustain=1.0, from=0.0, to=1.0, n=3;
		var step;
		sustain = sustain.value;
		step = (to - from) / n;
		Pbind(
			\instrument, \play_from_to,
			\from, Pseries(from, step, n),
			\to, Pseries(from, step, n) + step,
			\legato, 1.0,
			\dur, sustain / n
		)
})
)
