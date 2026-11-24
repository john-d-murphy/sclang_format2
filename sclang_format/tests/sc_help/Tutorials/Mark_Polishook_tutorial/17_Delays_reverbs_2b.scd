// Source: Tutorials/Mark_Polishook_tutorial/17_Delays_reverbs.schelp block 2 (part 2/2)
(
{
	AllpassN.ar(
		SinOsc.ar(500.rrand(1000), 0, 0.2) * Line.kr(1, 0, 0.1),
		0.1,
		0.025,
		6
	)
}.scope
)
