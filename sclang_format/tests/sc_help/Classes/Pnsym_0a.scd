// Source: Classes/Pnsym.schelp block 0 (part 1/8)
(
// load a synthdef
s.boot;
SynthDef("gpdef",
	{ arg out=0, freq=440, sustain=0.05, amp=0.1, pan;
		var env;
		env = EnvGen.kr(Env.perc(0.01, sustain), doneAction: Done.freeSelf) * amp;
		Out.ar(out, Pan2.ar(SinOsc.ar(freq, 0, env), pan))
	}).add;
)
