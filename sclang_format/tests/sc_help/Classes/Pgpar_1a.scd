// Source: Classes/Pgpar.schelp block 1 (part 1/2)
(
SynthDef(\gap, { arg out, sustain=1.0, attack=0.0001, decay=0.01, leak;
	var level;
	level = EnvGen.ar(Env.linen(attack, sustain, decay, 1-leak), doneAction: Done.freeSelf);
	XOut.ar(out, level, Silent.ar ! 2)
}).add;

SynthDef(\help_sinegrain,
	{ arg out=0, freq=440, sustain=0.05;
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
		Out.ar(out, SinOsc.ar(freq, 0, env))
}).add;
)
