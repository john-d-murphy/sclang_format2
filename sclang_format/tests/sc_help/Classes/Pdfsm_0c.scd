// Source: Classes/Pdfsm.schelp block 0 (part 3/5)
(
var p;
p = Pdfsm(
	[
		Prand([0,1,2],inf),	// signalStream

		IdentityDictionary[	// state 0
			0 -> [ 2, Pseq([67,68,69], 2) ],
			1 -> [ 0, 66 ],
			2 -> [ 1, 65 ]
		],
		IdentityDictionary[	// state 1
			1 -> [ 1, Pseq([69,68,67],2) ],
			\default -> [ 0, 70 ]
		],
		IdentityDictionary[
			0 -> [ 0, 71 ],
			1 -> [ 0, 72 ],
			2 -> [ nil ]	// signalStream is infinitely long,
					// so the fsm only ends because of this nil
					// 2 -> [nil, nil] is also fine
		]
	],
	1, 				// startState
	1 				// repeats
).asStream;

Routine({
	var freq;
	while({ (freq = p.next.postln).notNil },{
		Synth(\help_Pdfsm1, [ \freq, freq.midicps ]);
		0.1.wait;
	})
}).play;
)
