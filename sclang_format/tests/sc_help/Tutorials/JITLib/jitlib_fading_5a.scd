// Source: Tutorials/JITLib/jitlib_fading.schelp block 5 (part 1/2)
(
SynthDef("test", { arg gate=1, out;
	Out.ar(out,
		Formant.ar(Rand(20,40), 600, 10, 0.6)
		* EnvGen.kr(Env.perc, gate, doneAction: Done.freeSelf)
	)
}).send(s);
)
