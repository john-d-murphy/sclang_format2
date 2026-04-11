// Source: Classes/EnvGen.schelp block 2 (part 1/11)
(
{
	var env = Env([0.0, 0.5, 0.0, 1.0, 0.9, 0.0], [0.05, 0.1, 0.01, 1.0, 1.5], -4);
	var envgen = EnvGen.ar(env, Dust.ar(1));
	SinOsc.ar(
		envgen * 1000 + 440
	) * envgen * 0.1
}.play
);
