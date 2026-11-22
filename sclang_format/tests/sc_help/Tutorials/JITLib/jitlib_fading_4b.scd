// Source: Tutorials/JITLib/jitlib_fading.schelp block 4 (part 2/5)
(
SynthDef("test", { arg gate=1, out;
	Out.ar(out, Formant.ar(300, 200, 10) * EnvGen.kr(Env.asr, gate, doneAction: Done.freeSelf))
}).send(s);
)
