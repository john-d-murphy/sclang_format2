// Source: Classes/Env.schelp block 3
(
{
	EnvGen.kr(
		Env.new(
			levels: [0, 1, 0.5, 0],
			times: [0.01, 0.01, 0.01],
			releaseNode: 2 // sustains at level 0.5 until gate is closed
		),
		gate: Trig.kr(Impulse.kr(3), dur: 0.3)
	);
}.plot(duration: 1);
)
