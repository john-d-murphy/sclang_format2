// Source: Classes/Env.schelp block 31 (part 6/7)
(
SynthDef(\help_EnvBlend, { | out, factor = 0 |
	Out.ar(out, EnvGen.kr(blend(Env.perc, Env.sine, factor), 1.0, doneAction: Done.freeSelf)
		* SinOsc.ar(440,0,0.1)
	)
}).add
);
