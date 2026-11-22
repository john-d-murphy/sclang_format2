// Source: Tutorials/A-Practical-Guide/PG_06b_Time_Based_Patterns.schelp block 3 (part 1/4)
(
p = Pbind(
		// change to inf: we don't need to know exactly how many events are needed
	\degree, Pwhite(-4, 11, inf),
	\pan, Pif(Ptime(inf) <= 4.0, Env(#[-1, 1, -1], #[2, 2], \sin)),
	\dur, 0.125
).play;
)
