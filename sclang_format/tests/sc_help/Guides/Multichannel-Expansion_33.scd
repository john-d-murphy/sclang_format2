// Source: Guides/Multichannel-Expansion.schelp block 33
(
{
	var n;
	n = 8; // number of 'voices'
	Mix.new( // mix all stereo pairs down.
		Pan2.ar( // pan the voice to a stereo position
			CombL.ar( // a comb filter used as a string resonator
				Dust.ar( // random impulses as an excitation function
					// an array to cause expansion of Dust to n channels
					// 1 means one impulse per second on average
					Array.fill(n, 1),
					0.3 // amplitude
				),
				0.01, // max delay time in seconds
				// array of different random lengths for each 'string'
				Array.fill(n, {0.004.rand+0.0003}),
				4 // decay time in seconds
			),
			Array.fill(n,{1.0.rand2}) // give each voice a different pan position
		)
	)
}.play;
)
