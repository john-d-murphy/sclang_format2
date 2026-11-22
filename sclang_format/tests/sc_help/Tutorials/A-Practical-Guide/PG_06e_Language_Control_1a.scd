// Source: Tutorials/A-Practical-Guide/PG_06e_Language_Control.schelp block 1 (part 1/5)
p = Pbind(
		// the random seed is generated once, when creating the Pattern object
		// so the same random seed is used every time whenever this pattern object plays
	\degree, Pseed(0x7FFFFFFF.rand, Pseries({ rrand(-7, 0) }, Pwhite(1, 3, inf), { rrand(4, 10) })),
	\dur, 0.25
);
