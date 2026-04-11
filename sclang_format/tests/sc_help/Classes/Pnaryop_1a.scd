// Source: Classes/Pnaryop.schelp block 1 (part 1/5)
(
SynthDef(\help_sinegrain,
	{ arg out=0, freq=440, sustain=0.05, amp=0.1;
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain, 0.2, amp), doneAction: Done.freeSelf);
		Out.ar(out, SinOsc.ar(freq, 0, env))
	}).add;
)
