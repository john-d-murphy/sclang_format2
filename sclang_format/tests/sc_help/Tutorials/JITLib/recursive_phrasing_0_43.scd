// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 44/45)
(
Pdef(\poch, { arg sustain=1.0, from=0.0, to=1.0, n=3;
	var step, f, t, i;
	sustain = sustain.value;
	step = (to - from) / n;
	f = Array.series(n, from, step) +.t [0.0, step];
	i = n div: 2;
	f[i] = f[i].reverse;
	Pbind(
		\instrument, \play_from_to,
		[\from, \to], Pseq(f),
		\legato, 1.0,
		\dur, sustain / n
	)
})
)
