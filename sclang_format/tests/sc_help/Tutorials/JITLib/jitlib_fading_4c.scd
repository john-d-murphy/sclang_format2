// Source: Tutorials/JITLib/jitlib_fading.schelp block 4 (part 3/5)
(
SynthDef("test", { arg gate=1, out, fadeTime=1;
	Out.ar(out,
		Formant.ar(Rand(20,40), 600, 10, 0.2)
		* EnvGen.kr(Env.asr(fadeTime,1,fadeTime), gate, doneAction: Done.freeSelf)
	)
}).send(s);
)
