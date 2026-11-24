// Source: Tutorials/A-Practical-Guide/PG_06b_Time_Based_Patterns.schelp block 3 (part 3/4)
(
p = Pbind(
	\degree, Pwhite(-4, 11, inf),
	\pan, Pn(Pif(Ptime(inf) <= 4.0, Env(#[-1, 1, -1], #[2, 2], \sin)), inf),
	\dur, 0.125
).play;
)
