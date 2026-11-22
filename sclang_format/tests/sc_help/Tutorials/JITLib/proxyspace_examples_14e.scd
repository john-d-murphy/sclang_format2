// Source: Tutorials/JITLib/proxyspace_examples.schelp block 14 (part 5/15)
(
SynthDef("staub", { arg out, gate=1, fadeTime = 0.1;
	Out.ar(out,
		Ringz.ar(Dust.ar(15), Rand(1, 3) * 3000*[1,1], 0.001)
		* EnvGen.kr(Env.asr(fadeTime, 1, fadeTime), gate, doneAction: Done.freeSelf)
	)
}).add;
)
