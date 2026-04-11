// Source: Classes/EnvGen.schelp block 1 (part 3/3)
(
{
	SinOsc.ar(
		EnvGen.kr(
			Env.circle([0, 1, 0, (2..4), 0, LFNoise1.kr(0.1 ! 5) * 10, 0], [0.01, 0.6])
		)
		* 240 + 300
	).sum * 0.2
}.play;
)
