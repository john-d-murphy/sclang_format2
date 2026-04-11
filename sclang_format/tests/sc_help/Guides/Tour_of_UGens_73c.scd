// Source: Guides/Tour_of_UGens.schelp block 73 (part 3/4)
(
{
	// mixing sine oscillators in parallel
	var n = 16; // number of structures to make
	// mix together  parallel structures
	Mix.fill(n,
			{
				var amp;
				amp = FSinOsc.kr(exprand(0.1,1),2pi.rand).max(0);
				Pan2.ar(
					FSinOsc.ar(exprand(100,1000.0), 0, amp),
					1.0.rand2)
			}
	) / (2*n)			// scale amplitude
}.scope(2);
)
