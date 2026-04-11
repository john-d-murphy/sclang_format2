// Source: Classes/RandSeed.schelp block 0 (part 11/11)
(
fork {
	var id=0;
	(1902..2005).do { |seed|
		seed.postln;
		3.do {
			Synth("pseudorandom", [\seed, seed, \id, id]);
			id = id + 1 % 16; // there is 16 different random generators
			0.8.wait;
		}
	}
}
)
