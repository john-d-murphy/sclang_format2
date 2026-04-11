// Source: Tutorials/A-Practical-Guide/PG_06d_Parallel_Patterns.schelp block 0 (part 1/2)
(
p = Pspawner({ |sp|	// sp = the Spawner object
	loop {
			// run a new pattern in parallel
			// the pattern is finite
			// after a few events, it stops and the Pspawner forgets about it
		sp.par(Pbind(
			\degree, Pseries(rrand(-5, 7), #[-1, 1].choose, rrand(4, 7)),
			\pan, rrand(-1.0, 1.0),
			\dur, rrand(0.1, 0.3)	// duration is chosen once for each pattern
		));
			// tell the Spawner to wait a bit before the next pattern goes
			// DO NOT use numBeats.wait for this!
			// Everything must go through the Spawner
		sp.wait(rrand(1, 4) * 0.25);
	}
}).play;
)
