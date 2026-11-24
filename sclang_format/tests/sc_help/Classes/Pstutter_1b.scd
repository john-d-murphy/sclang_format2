// Source: Classes/Pstutter.schelp block 1 (part 2/10)
(
SynthDef(\help_sinegrain,
	{ |out = 0, freq = 440, sustain = 0.05|
		var env;
        env = Env.perc(0.01, sustain, 0.2).kr(doneAction: Done.freeSelf);
		Out.ar(out, SinOsc.ar(freq, 0.5pi, env))
	}).add;
)
