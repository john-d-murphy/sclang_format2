// Source: Classes/Pattern.schelp block 9 (part 8/10)
Pbind(\degree,
	Prewrite(0, (
			0: #[2, 0],
			1: #[0, 0, 1],
			2: #[1, 0, 1]
		), 4
	) + Pn(Env([4, 0, 1, 4, 3, 4], [6.4, 6.4, 6.4, 6.4, 6.4], 'step')),
	\dur, 0.2).play
