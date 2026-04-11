// Source: Tutorials/JITLib/proxyspace_examples.schelp block 17 (part 15/18)
(
~out = SynthDef("a", { arg out, freq=800;
		var env;
		env = EnvGen.kr(Env.perc(0.01, 0.1, 0.3),doneAction: Done.freeSelf);
		Out.ar(out, Pulse.ar(freq * Rand([0.9,0.9], 1.1), 0.5, env) )
	});
)
