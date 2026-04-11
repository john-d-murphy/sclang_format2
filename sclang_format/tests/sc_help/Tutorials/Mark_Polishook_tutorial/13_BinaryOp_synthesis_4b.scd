// Source: Tutorials/Mark_Polishook_tutorial/13_BinaryOp_synthesis.schelp block 4 (part 2/2)
(
	// scaling and mixing
	// ... imitates a train?
	{
		(WhiteNoise.ar(0.1) * SinOsc.kr(1, 1))
		+
		(BrownNoise.ar(0.1) * SinOsc.kr(2, 1))

	}.scope;
)
