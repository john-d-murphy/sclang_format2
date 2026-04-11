// Source: Classes/RandSeed.schelp block 0 (part 7/11)
(
fork {
	loop {
		Synth("pseudorandom");
		1.1.wait; // wait a bit longer than sustain, so sounds don't overlap
	}
}
)
