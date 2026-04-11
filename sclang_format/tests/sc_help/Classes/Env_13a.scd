// Source: Classes/Env.schelp block 13 (part 1/5)
(
SynthDef(\env_help, { |out, gate = 1, amp = 0.1, release = 0.1|
	var env = Env.adsr(0.02, release, amp);
	var gen = EnvGen.kr(env, gate, doneAction: Done.freeSelf);
	Out.ar(out, PinkNoise.ar(1 ! 2) * gen)
}).add
);
