// Source: Classes/Env.schelp block 1
(
{
	EnvGen.kr(
		Env(
			levels: [0, 0.1, 0.2, 0.3],
			times: [0.1, 0.1, 0.1],
			curve: 8
		),
		gate: Impulse.kr(3)
	);
}.plot(duration: 1);
)
