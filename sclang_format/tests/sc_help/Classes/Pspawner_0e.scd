// Source: Classes/Pspawner.schelp block 0 (part 5/17)
(
// manipulate basic pattern with Pchain
Pchain(
	Pbind(*[mtranspose: Pkey(\mtranspose) + Pdup(8, Prand([0, [0, 3, -2], [0, 2, 4]], inf))]), // make some notes into triads
	Pbind(*[ctranspose: Pwhite(-0.1, 0.1)]), // add random detuning to notes
	Pbind(*[\scale, Scale.minor]), // alter the scale
	Pn(Pseq([p, (type: \rest, dur: 1.0)])), // repeat the pattern after a 1 second pause
	Pbind(*[
		db: Pstep(Pseq([-10, -13, -13, -11, -13, -13], inf), 0.1) - 10,
		mtranspose: Pstep(Pwhite(-7, 7), Prand([5, 4, 2], inf)) // random modal transposition
	])
).play(protoEvent: Event.default)
)
