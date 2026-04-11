// Source: Tutorials/Mark_Polishook_tutorial/13_BinaryOp_synthesis.schelp block 1 (part 1/2)
(
	// mix 2 sawtooth waves
	{
		Saw.ar(500, 0.05)	// receiver
		+			// operator
		Saw.ar(600, 0.06)	// operand
	}.scope;
)
