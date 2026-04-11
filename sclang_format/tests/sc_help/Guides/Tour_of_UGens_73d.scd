// Source: Guides/Tour_of_UGens.schelp block 73 (part 4/4)
(
{
	var n;
	n = 8; // number of 'voices'
	Mix.ar( // mix all stereo pairs down.
		Pan2.ar( // pan the voice to a stereo position
			CombL.ar( // a comb filter used as a string resonator
				Dust.ar( // random impulses as an excitation function
					// an array to cause expansion of Dust to n channels
					// 1 means one impulse per second on average
					1.dup(n),
					0.3 // amplitude
				),
				0.01, // max delay time in seconds
				// array of different random lengths for each 'string'
				{0.004.rand+0.0003}.dup(n),
				4 // decay time in seconds
			),
			{1.0.rand2}.dup(n) // give each voice a different pan position
		)
	)
}.scope(2, zoom:4);
)
