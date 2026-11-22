// Source: Classes/Pspawner.schelp block 0 (part 2/17)
(
// example 2: create 6 streams at 4 second intervals
// then delete them in the order they were created

Pspawner({ |sp|
	var streams, stream;
	// start patterns, collect the resultant event streams
	streams = [2, 3, 4, 6, 7, 8].collect { |i|
		stream = sp.par(Pbind(*[
			harmonic: i,
			ctranspose: 	[0, 1, 3]/40,
			octave:	Pbrown(2, 8, 2), dur: 1/i, db: -30
		]));
		sp.wait(4);
		stream;
	};

	// now stop those streams one by one
	streams.do { |s| sp.suspend(s); sp.wait(4) };
}).play
)
