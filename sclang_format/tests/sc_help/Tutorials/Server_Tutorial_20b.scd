// Source: Tutorials/Server_Tutorial.schelp block 20 (part 2/8)
(
// define an echo effect
SynthDef("echo", { arg delay = 0.2, decay = 4;
	var in;
	in = In.ar(0,2);
	// use ReplaceOut to overwrite the previous contents of the bus.
	ReplaceOut.ar(0, CombN.ar(in, 0.5, delay, decay, 1, in));
}).add;
)
