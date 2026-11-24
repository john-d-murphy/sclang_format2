// Source: Tutorials/A-Practical-Guide/PG_06b_Time_Based_Patterns.schelp block 2 (part 5/6)
p = Pbind(
	\degree, Pwhite(-4, 11, 32),
	\pan, Env(#[-1, 1, -1], #[2, 2], \sin),
	\dur, 0.125
).play;
