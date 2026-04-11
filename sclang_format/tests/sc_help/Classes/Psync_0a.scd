// Source: Classes/Psync.schelp block 0 (part 1/8)
(
SynthDef(\help_sinegrain,
	{ arg out=0, freq=440, sustain=0.05, pan;
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain, 0.3), doneAction: Done.freeSelf);
		Out.ar(out, Pan2.ar(SinOsc.ar(freq, 0, env), pan))
	}).add;
)
