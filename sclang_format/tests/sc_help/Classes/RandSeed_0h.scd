// Source: Classes/RandSeed.schelp block 0 (part 8/11)
(
fork {
	(1902..2005).do { |seed|
		seed.postln;
		3.do {
			Synth("pseudorandom", [\seed, seed]);
			1.1.wait;
		}
	}
}
)
