// Source: Classes/EnvGen.schelp block 9 (part 1/9)
(
SynthDef(\env, { arg i_outbus=0;
	var env, envctl;

	// make a dummy 8 segment envelope
	env = Env.newClear(8);

	// create a control argument array
	envctl = \env.kr( env.asArray );

	ReplaceOut.kr(i_outbus, EnvGen.kr(envctl, doneAction: Done.freeSelf));
}).add;
)
