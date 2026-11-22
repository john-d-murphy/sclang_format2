// Source: Classes/PlazyEnvirN.schelp block 1 (part 1/4)
(
SynthDef(\help_sinegrain,
	{ |out = 0, freq = 440, sustain = 0.05, pan = 0|
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
		Out.ar(out, Pan2.ar(SinOsc.ar(freq, 0, env), pan))
	}).add;

a = PlazyEnvirN({ |g = 0, h = 0, dur = 1|
	postf("g: %, h: %, dur: %\n", g, h, dur);

	Pbind(
		\instrument, \help_sinegrain,
		\dur, dur,
		\degree, Pseq([g, g, h, g, h], 2)
	)
});
)
