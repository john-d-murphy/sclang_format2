// Source: Classes/Pdfsm.schelp block 0 (part 5/5)
(
var n=3, base, penult;

base = [3,4,4,0];

for( 1, n, { arg i;
	penult = Pbind( \degree, Pshuf(base - (i*5), 2), \dur, Pseq([0.2],2) );
	Pset(
		\instrument, \help_Pdfsm2,
		Pdfsm(
			[
				Pseq([	// signalStream
					Pn(1,22 + i),
					Pn(0,4),
					Pn(1,8),
					Pseq([
						Pn(0,3),
						Prand([0,1],8),
						Pn(1,8)
					], 3 ),
					Pn(2,2)
				], 1 ),
				(	// state 0
					0 : [ 0, Pbind( \degree, Pseq(base - i, 1), \dur, Pxrand([0.2,0.3],4) ) ],
					1 : [ 1, Pbind(
							\degree, Pseq(base.reverse - (i*2), 2),
							\dur, Pseq([0.2,0.21],1)
							)
						],
					2 :	[ 2, penult ]
				),
				(	// state 1
					0 : [ 0, Pbind( \degree, Pshuf(base * i.neg, 8), \dur, Pseq([0.08],8) ) ],
					1 : [ 0, Pbind( \degree, Pseq(base - (i*3),3+i), \dur, Pseq([0.11],3+i) ) ],
					2 : [ 2, penult ]
				),
				(	// state 2
					\default : [ 2, Pbind(
									\degree, Prand(base - (i*7), 5),
									\dur, Prand([0.6,0.8],5)
								)
							]
				)
			],
			i % 2 		// startState
		)
	).play;
})
)
