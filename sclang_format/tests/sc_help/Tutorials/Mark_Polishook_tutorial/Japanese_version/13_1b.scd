// Source: Tutorials/Mark_Polishook_tutorial/Japanese_version/13.schelp block 1 (part 2/4)
(
{
	AllpassN.ar(
		SinOsc.ar(500.rrand(1000), 0, 0.2) * Line.kr(1, 0, 0.1),
		0.3,
		0.25,
		6
	)
}.scope;
)
