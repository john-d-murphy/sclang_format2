// Source: Tutorials/Mark_Polishook_tutorial/09_Buses.schelp block 1 (part 1/2)
(
SynthDef("dataForABus", {
	Out.ar(
		0,		// write 1 channel of audio into bus 0
		Saw.ar(100, 0.1)
	)
}).add;
)
