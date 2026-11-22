// Source: Classes/Plambda.schelp block 0 (part 2/4)
(
SynthDef(\sine,
	{ |out = 0, freq = 440, sustain = 0.05, pan = 0, amp = 0.1|
		var env;
		env = EnvGen.kr(Env.perc(Rand(0.001, 0.02), sustain, AmpCompA.kr(freq)*amp), doneAction: Done.freeSelf);
		Out.ar(out, Pan2.ar(SinOsc.ar(freq), pan, env))
	}).add;
)
