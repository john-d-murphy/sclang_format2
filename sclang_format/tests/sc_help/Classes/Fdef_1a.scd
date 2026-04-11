// Source: Classes/Fdef.schelp block 1 (part 1/7)
(
s.boot;
SynthDef("gpdef",
	{ arg out=0, freq=440, sustain=0.05, amp=0.1;
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain), doneAction: Done.freeSelf) * amp;
		Out.ar(out, SinOsc.ar(freq, 0, env))
	}).add;
)
