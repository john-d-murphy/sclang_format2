// Source: Tutorials/A-Practical-Guide/PG_06a_Repetition_Contraint_Patterns.schelp block 0 (part 5/6)
p = Pbind(
	\degree, Pdup(Pwhite(3, 10, inf), Pwhite(-4, 11, inf)),
	\dur, Pclutch(Pwhite(0.1, 0.4, inf), Pdiff(Pkey(\degree)).abs > 0),
	\legato, 0.3
).play;
