// Source: Classes/RandSeed.schelp block 0 (part 9/11)
(
fork {
	(1902..2005).do { |seed|
		seed.postln;
		rrand(4,10).do {
			Synth("pseudorandom", [\seed, seed, \sustain, 0.05]);
			0.06.wait;
		}
	}
}
)
