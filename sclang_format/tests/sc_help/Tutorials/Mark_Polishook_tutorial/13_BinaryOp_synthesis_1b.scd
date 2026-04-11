// Source: Tutorials/Mark_Polishook_tutorial/13_BinaryOp_synthesis.schelp block 1 (part 2/2)
(
// mix 3 unit generators.
	{
		Saw.ar(500, 0.05)	// receiver
		+			// operator
		Saw.ar(600, 0.06)	// operand
						// when evaluated produce
						// a BinaryOpUGen
						// this BinaryOpUGen is then a receiver for an
		+				// addition operator followed by
		Saw.ar(700, 0.07)		// an operand
	}.scope;
)
