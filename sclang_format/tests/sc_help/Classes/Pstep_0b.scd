// Source: Classes/Pstep.schelp block 0 (part 2/9)
(
Pchain(
	Ppar([
		Pbind(
			\degree, Pbrown(0, 12, 1),
			\dur, Pstep(Pseq([0.1, 0.2, 0.4, 0.8, 1.6], inf), 3.2)
		),
		Pbind(
			\degree, Pbrown(0, 20, 1),
			\dur, Pstep(Pseq([0.1, 0.2, 0.4, 0.8, 1.6], inf), 4.5)
		)
	]),
	Pbind(
		\scale, Pstep(Pseq([[0, 2, 4, 5, 7, 9, 11], [0, 1, 2, 3, 4, 5, 6]], inf), 5),
		\db, Pstep(Pseq([2, -2, 0, -2], inf), 0.25) - 10
	)
).play;
)
