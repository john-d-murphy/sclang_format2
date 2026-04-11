// Source: Guides/Spawning.schelp block 3 (part 3/4)
(
SynthDef("help-EnvGen",{ arg out = 0;
	Out.ar(
		out,
		EnvGen.kr(Env.perc,1.0,doneAction: Done.freeSelf) * SinOsc.ar(440,0,0.1)
	)
}).send(s);
)
