// Source: Tutorials/Mark_Polishook_tutorial/13_BinaryOp_synthesis.schelp block 9
(
{	var n = 12;

	Mix.arFill(
			n,						// generate n sine waves
			{
			SinOsc.ar(					// each with a possible frequency between
				[67.0.rrand(2000), 67.0.rrand(2000)],	// low.rrand(high) ... floating point values
				0,
				n.reciprocal				// scale the amplitude of each sine wave
									// according to the value of n
			)
			*
			EnvGen.kr(					// put an envelope on each of the sine waves
				Env.sine(2.0.rrand(17)),
				doneAction: Done.none 				// deallocate envelopes only when the
									// entire sound is complete (why?)
			)
		}
	)
	*								// put an envelope over the whole patch
	EnvGen.kr(
		Env.perc(11, 6),
		doneAction: Done.freeSelf,
		levelScale: 0.75
	)

}.scope
)
