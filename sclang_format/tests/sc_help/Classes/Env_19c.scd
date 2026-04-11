// Source: Classes/Env.schelp block 19 (part 3/27)
(
{
	var levels = (1..30);
	var env = Env([1, levels, 0.5, levels / 2.5, 2], [1, 0.15, 1, 0.25, 0.1], \exp);
	Splay.ar(SinOsc.ar(EnvGen.kr(env) * 400 + 600)) * 0.1
}.play;
);
