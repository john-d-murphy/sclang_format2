// Source: Tutorials/Mark_Polishook_tutorial/17_Delays_reverbs.schelp block 1 (part 1/2)
(
{
	CombN.ar(
		SinOsc.ar(500.rrand(1000), 0, 0.2) * Line.kr(1, 0, 0.1),
		0.3,
		0.25,
		6
	)
}.scope;
)
