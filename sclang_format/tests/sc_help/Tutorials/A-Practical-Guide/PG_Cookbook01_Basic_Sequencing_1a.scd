// Source: Tutorials/A-Practical-Guide/PG_Cookbook01_Basic_Sequencing.schelp block 1 (part 1/2)
(
p = Pbind(
	\degree, Pseries(7, Pwhite(1, 3, inf) * Prand(#[-1, 1], inf), inf).fold(0, 14)
		+ Prand(#[[0, -2, -4], [0, -3, -5], [0, -2, -5], [0, -1, -4]], inf),
	\dur, Pwrand(#[1, 0.5], #[0.8, 0.2], inf)
).play;
)
