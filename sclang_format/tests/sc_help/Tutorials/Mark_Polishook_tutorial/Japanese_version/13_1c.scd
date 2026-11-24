// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/13.schelp block 1 (part 3/4)
(
{
	CombN.ar(
		SinOsc.ar(500.rrand(1000), 0, 0.2) * Line.kr(1, 0, 0.1),
		0.1,
		0.025,
		6
	)
}.scope;
)
