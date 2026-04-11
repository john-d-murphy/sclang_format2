// Source: Tutorials/JITLib/proxyspace_examples.schelp block 17 (part 3/18)
(
~out = SynthDef("a", { arg out=0, freq=800, pmf=1.0, pan;
		var env, u;
		env = EnvGen.kr(Env.perc(0.001, 0.04, 0.4),doneAction: Done.freeSelf); // envelope
		u = SinOsc.ar(freq * Rand(0.9, 1.1), SinOsc.ar(pmf, 0, pi), env);
		Out.ar(out, Pan2.ar(u, pan))
	})
);
