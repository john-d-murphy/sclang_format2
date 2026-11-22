// Source: Tutorials/JITLib/proxyspace_examples.schelp block 15 (part 1/17)
(
SynthDef(\who, { arg amp=0.1, freq=440, detune=0, gate=1, out=0, ffreq=800;
	var env;
	env = Env.asr(0.01, amp, 0.5);
	Out.ar(out, Pan2.ar(
		Formant.ar(freq + detune, ffreq, 30, EnvGen.kr(env, gate, doneAction: Done.freeSelf)), Rand(-1.0, 1.0))
	)
}).add;

)
