// Source: Tutorials/JITLib/proxyspace_examples.schelp block 14 (part 4/15)
(
~out = SynthDef("w", { arg out=0, gate=1.0, fadeTime = 0.1;
	Out.ar(out,
		SinOsc.ar([Rand(430, 800), Rand(430, 800)], 0, 0.2)
			* EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: Done.freeSelf)
	)
	});
)
