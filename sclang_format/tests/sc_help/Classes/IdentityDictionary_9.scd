// Source: Classes/IdentityDictionary.schelp block 9
(
SynthDef(\help_sinegrain, { |out = 0, freq = 440, sustain = 0.05|
	var env;
	env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.freeSelf);
	Out.ar(out, SinOsc.ar(freq, 0.5pi, env))
}).add;

a = Pbind(\instrument, \help_sinegrain, \note, Pseq([0, 7, 2, 9, 11, 10, 9, 8], inf), \dur, 1);
a.play(quant: (quant: 1, phase: 0));
a.play(quant: (quant: 1, phase: 1/3));
a.play(quant: (quant: 1, phase: 1.0.rand));
)
