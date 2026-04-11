// Source: Classes/Env.schelp block 14
(
{
	var env = Env.step([0, 3, 5, 2, 7, 3, 0, 3, 4, 0], [0.5, 0.1, 0.2, 1.0, 1.5, 2, 0.2, 0.1, 0.2, 0.1]);
	var envgen = EnvGen.kr(env);
	var freq = (envgen + 60).midicps;
	SinOsc.ar(freq) * 0.1
}.play
);
