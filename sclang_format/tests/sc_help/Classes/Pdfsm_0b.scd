// Source: Classes/Pdfsm.schelp block 0 (part 2/5)
(
SynthDef(\help_Pdfsm1,
	{ arg out=0, freq=440, sustain=0.05;
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
		Out.ar(out, SinOsc.ar([freq, freq + 0.1.rand2], 0, env))
	}).add;
)
