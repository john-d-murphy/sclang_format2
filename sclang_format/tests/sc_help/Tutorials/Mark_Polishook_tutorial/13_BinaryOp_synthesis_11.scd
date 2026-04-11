// Source: Tutorials/Mark_Polishook_tutorial/13_BinaryOp_synthesis.schelp block 11
(
	{
		SinOsc.ar(440, 0, 0.571)
		*
		(SinOsc.kr(880).abs			// wrap the modulator and the lfo in parenthese
		* 					// why ... ?
		SinOsc.kr([6.99, 8.01].reciprocal)
		)
	}.scope
)
