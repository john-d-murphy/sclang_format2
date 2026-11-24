// Source: Classes/Place.schelp block 0 (part 10/11)
(
SynthDef("help-sinegrain",
	{ |out = 0, freq = 440, sustain = 0.05|
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
		Out.ar(out, SinOsc.ar(freq, 0, env))
	}).add;
)
