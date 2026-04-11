// Source: Classes/Tdef.schelp block 3 (part 1/9)
(
// load a synthdef
s.boot;
SynthDef(\pdef_grainlet,
	{ arg out=0, freq=440, sustain=0.05;
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain, 0.3), doneAction: Done.freeSelf);
		Out.ar(out, SinOsc.ar(freq, 0, env))
	}).add;
)
