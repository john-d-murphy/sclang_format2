// Source: Classes/Pstep.schelp block 0 (part 3/9)
(
Pchain(
	Ppar([
		Pbind(
			\octave, [5, 6] + Prand([0, 0, \r], inf),
			\degree, Prout({ |ev| loop { ev = Pseq(ev[\degree]).embedInStream } }),
			\dur,	Prout({ loop { Pseq([0.2, 0.2, 0.2, 0.2, 0.3].scramble).embedInStream } })
		),
		Pbind(
			\octave, 4,
			\legato, 1.2,
			\dur, Prout({ loop { Pseq([0.2, 0.2, 0.2, 0.2, 0.3].scramble * 5).embedInStream } })
		),
	]),
	Pstep(Pbind(
		\db, Pseq([0, -4, -2, -4, -3, -4, -3, -4], inf) - 20
	), 0.2),
	Pstep(
		Pbind(
			\degree, 	Pfunc({ { 10.rand }.dup(10) }),
			\scale,	Pfunc({ { rrand(1, 2) }.dup(7).integrate })
		),
		5
	)
).play
)
