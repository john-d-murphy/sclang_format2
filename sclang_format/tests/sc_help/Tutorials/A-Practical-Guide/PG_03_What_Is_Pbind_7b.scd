// Source: Tutorials/A-Practical-Guide/PG_03_What_Is_Pbind.schelp block 7 (part 2/2)
p = Pbind(
		// Use \harpsi, not \default
	\instrument, \harpsi,
	\degree, Pseries(0, 1, 8),
	\dur, 0.25
).play;
