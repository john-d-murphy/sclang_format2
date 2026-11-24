// Source: Classes/Pspawner.schelp block 0 (part 3/17)
(
// example 3: define a Pspawner and use Pattern manipulations
p = Pspawner({ |sp|
	var pat = Pbrown(-7, 7, 3);

	sp.par(Pbind(*[octave: 5, degree: pat, dur: 1/4]));
	sp.wait(2);
	sp.par(Pbind(*[octave: 6, degree: pat, dur: 1/8]));
	sp.wait(3);
	sp.par(Pbind(*[octave: 7, degree: pat, dur: 1/6, db: -20]));
	sp.wait(4);
	sp.par(Pbind(*[octave: 4, degree: pat, dur: 1/4]));

	sp.wait(8);
	sp.suspendAll;
});
)
