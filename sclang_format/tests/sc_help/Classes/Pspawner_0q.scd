// Source: Classes/Pspawner.schelp block 0 (part 17/17)
(
Pspawner({ |sp|
	(1..5).do { |i|
		sp.par(Pbind(*[
			octave: i + 2,
			degree:	Pwhite(0, 7), dur: 1/i, db: -30
		]));
		sp.wait(4);
	};
	sp.suspendAll;
}).play
)
