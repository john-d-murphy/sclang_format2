// Source: Classes/IEnvGen.schelp block 0 (part 1/3)
(
{
	var env =  Env([0, 0.6, 0.3, 1.0, 0], [0.1, 0.02, 0.4, 1.1], [\lin, \exp, -6, \sin]);
	var envgen = IEnvGen.kr(env, MouseX.kr(0, env.times.sum));
	env.plot;
	SinOsc.ar(envgen * 500 + 440)
}.play;
)
