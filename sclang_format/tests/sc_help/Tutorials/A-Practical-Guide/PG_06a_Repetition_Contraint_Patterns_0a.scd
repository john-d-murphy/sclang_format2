// Source: Tutorials/A-Practical-Guide/PG_06a_Repetition_Contraint_Patterns.schelp block 0 (part 1/6)
p = Pbind(
		// making 'n' a separate stream so that degree and dur can share it
	\n, Pwhite(3, 10, inf),
	\degree, Pdup(Pkey(\n), Pwhite(-4, 11, inf)),
	\dur, Pdup(Pkey(\n), Pwhite(0.1, 0.4, inf)),
	\legato, 0.3
).play;
