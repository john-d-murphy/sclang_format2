// Source: Tutorials/A-Practical-Guide/PG_06d_Parallel_Patterns.schelp block 1 (part 1/2)
(
p = Pspawn(Pbind(
	\method, \par,		// embed patterns in parallel
		// generate the subpattern in a Pfunc (so there's a new pattern each time)
		// Pfunc returns the pattern without rendering the stream
		// -- important for Pspawn
		// See the Pspawn helpfile for other ways to embed patterns
	\pattern, Pfunc {
		Pbind(
			\degree, Pseries(rrand(-5, 7), #[-1, 1].choose, rrand(4, 7)),
			\pan, rrand(-1.0, 1.0),
			\dur, rrand(0.1, 0.3)	// duration is chosen once for each pattern
		)
	},
		// The \delta key is used automatically for the spawner.wait() call
	\delta, Pwhite(1, 4, inf) * 0.25
)).play;
)
