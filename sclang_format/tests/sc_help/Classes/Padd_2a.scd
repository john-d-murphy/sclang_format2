// Source: Classes/Padd.schelp block 2 (part 1/2)
(
SynthDef(\sinegrain,
	{ arg out=0, freq=440, gate=1;
		var env;
		env = EnvGen.kr(Env.asr(0.001, 1, 0.2), gate, doneAction: Done.freeSelf);
		Out.ar(out, SinOsc.ar(freq, 0, env * 0.1))
	}).add;
)
