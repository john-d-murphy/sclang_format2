// Source: Tutorials/Mark_Polishook_tutorial/09_Buses.schelp block 3 (part 1/2)
(
SynthDef("dataFromABus", {
	Out.ar(
		0,
		[	// the left channel gets input from an audio bus
			In.ar(0, 1),
			SinOsc.ar(440, 0.2)
		]
	)
}).add;
)
