// Source: Classes/Pattern.schelp block 9 (part 10/10)
Pbind(
	\octave, 4,
	\degree, PstepNadd(
		Pseq([1, 2, 3]),
		Pseq([0, -2, [1, 3], -5]),
		Pshuf([1, 0, 3, 0], 2)
	),
	\dur, PstepNadd(
		Pseq([1, 0, 0, 1], 2),
		Pshuf([1, 1, 2, 1], 2)
	).loop * (1/8),
	\legato, Pn(Pshuf([0.2, 0.2, 0.2, 0.5, 0.5, 1.6, 1.4], 4), inf),
	\scale, #[0, 1, 3, 4, 5, 7, 8]
).play;
