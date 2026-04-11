// Source: Guides/Tour_of_UGens.schelp block 73 (part 1/4)
(
{
	// mixing sine oscillators in parallel
	var n = 16; // number of structures to make
	// mix together  parallel structures
	Mix.fill(n,
			// this function creates an oscillator at a random frequency
			{ FSinOsc.ar(200 + 1000.0.rand) }
	) / (2*n)			// scale amplitude
}.scope(1);
)
