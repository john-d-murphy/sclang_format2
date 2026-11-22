// Source: Tutorials/JITLib/proxyspace_examples.schelp block 14 (part 7/15)
(
~out = SynthDef("w", { arg out, lfo, f0=430;
	Out.ar(out,
		SinOsc.ar([Rand(f0, 800), Rand(f0, 800)]+lfo, 0, 0.2)
			* EnvGen.kr(Env.perc(0.01, 0.03), doneAction: Done.freeSelf)
	)
	});
)
