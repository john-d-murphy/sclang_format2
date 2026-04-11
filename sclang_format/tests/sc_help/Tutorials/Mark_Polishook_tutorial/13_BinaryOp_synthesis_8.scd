// Source: Tutorials/Mark_Polishook_tutorial/13_BinaryOp_synthesis.schelp block 8
(
{	// evaluate the function 12 times
	var n = 12;
	Mix.arFill(
		n,
		{
			SinOsc.ar(
				[67.0.rrand(2000), 67.0.rrand(2000)],
				0,
				n.reciprocal * 0.75
			)
		}
	)
	*
	EnvGen.kr(Env.perc(11, 6), doneAction: Done.freeSelf)
}.scope
)
