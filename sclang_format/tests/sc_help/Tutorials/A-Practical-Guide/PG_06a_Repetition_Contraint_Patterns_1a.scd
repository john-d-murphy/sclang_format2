// Source: Tutorials/A-Practical-Guide/PG_06a_Repetition_Contraint_Patterns.schelp block 1 (part 1/4)
p = Pn(Pbind(
		// always a low C on the downbeat
	\degree, Pseq([-7, Pwhite(0, 11, inf)], 1),
	\dur, Pconst(4, Pwhite(1, 4, inf) * 0.25)
), inf).play;
