// Source: Classes/Pspawner.schelp block 0 (part 1/17)
(
Pspawner({ |sp|

// parallel in-c'ish pulses will run throughout the example
	sp.par(Pbind(*[degree: [0, 7], octave: 7, dur: 0.2, db: Pseq([-20, -24, -22, -24], inf)]));

// scales in sequence with pauses
	sp.seq(
		Pbind(*[degree: Pseq((0..7).mirror), dur: 0.2])
	);
	sp.wait(0.4);
	sp.seq(
		Ppar([
			Pbind(*[degree: Pseq((0..7).mirror), dur: 0.2, octave: 4]),
			Pbind(*[degree: Pseq((0..7).reverse.mirror), dur: 0.2])
		])

	);
	sp.wait(3);
	sp.seq(
		Pbind(*[degree: Pseq((0..7).mirror), dur: 0.2, mtranspose: (0, 2..14)])
	);

// scales overlaped at 0.4 second intervals

	10.do {
		sp.par(
			Pbind(*[degree: Pseq((0..7).mirror), dur: 0.2])
		);

		sp.wait(0.4)
	};
	sp.wait(1.6);
	sp.suspendAll;
}).play
)
