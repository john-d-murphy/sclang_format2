// Source: Classes/Env.schelp block 19 (part 2/27)
(
{
	var env = Env([1, [1, 2, 3], 0.5, 0.5, [3, 2, 1], 2], [1, 1, 0.5, 1], [[\exp, \sin]]);
	env.plot;
	Splay.ar(SinOsc.ar(EnvGen.kr(env) * 400 + 600)) * 0.1
}.play;
);
