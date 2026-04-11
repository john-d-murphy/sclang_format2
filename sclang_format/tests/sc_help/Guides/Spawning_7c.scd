// Source: Guides/Spawning.schelp block 7 (part 3/3)
(
// this receives the trigger on the client side and 'Spawns' a new Synth on the server
OSCFunc({
	SynthDef("help-EnvGen", { arg out = 0;
		Out.ar(
			out,
			EnvGen.kr(Env.perc, 1.0, doneAction: Done.freeSelf)
			* SinOsc.ar(440, 0, 0.1)
		)
	}).play(s);
}, '/tr', s.addr);

// Start 'spawning'
Synth("help-SendTrig");
)
