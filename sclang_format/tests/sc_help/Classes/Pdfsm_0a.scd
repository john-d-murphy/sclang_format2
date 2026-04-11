// Source: Classes/Pdfsm.schelp block 0 (part 1/5)
(
	p = Pdfsm(
		[
			Pseq( [\foo,\bar], 2 ), // foobar signals
			( // state 0
				\foo : [ 1, Pseq([ 0, 1 ], 2 ) ]
			),
			( // state 1
				\bar : [ 0, 3 ]
			)
		],
		0,
		2
	).asStream;

	11.do({ p.next.postln });
)
