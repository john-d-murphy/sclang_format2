// Source: Tutorials/JITLib/proxyspace_examples.schelp block 18 (part 2/11)
(
SynthDef("grain", { arg i_out = 0, pan;
	var env;
	env = EnvGen.kr(Env.perc(0.001, 0.003, 0.2),doneAction: Done.freeSelf);
	Out.ar(i_out, Pan2.ar(FSinOsc.ar(Rand(1000,10000)), pan) * env)
}).send(s);
)
