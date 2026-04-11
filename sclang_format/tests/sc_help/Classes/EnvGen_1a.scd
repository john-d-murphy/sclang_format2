// Source: Classes/EnvGen.schelp block 1 (part 1/3)
(
{
	var env = Env([0, 1, 0.5, 1, 0], [0.01, 0.5, 0.02, 0.5]);
	SinOsc.ar(470) * EnvGen.kr(env, doneAction: Done.freeSelf)
}.play
)
