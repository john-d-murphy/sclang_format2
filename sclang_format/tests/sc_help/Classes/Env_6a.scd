// Source: Classes/Env.schelp block 6 (part 1/4)
(
SynthDef(\help_Env_newClear, { |out = 0, gate = 1|
	var env, envctl;
	// make an empty 4 segment envelope
	env = Env.newClear(4);
	// create a control argument array
	envctl = \env.kr(env.asArray);
	Out.ar(out, SinOsc.ar(EnvGen.kr(envctl, gate), 0) * -12.dbamp);
}).add;
)
