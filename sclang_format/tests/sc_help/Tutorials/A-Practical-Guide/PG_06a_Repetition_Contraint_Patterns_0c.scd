// Source: Tutorials/A-Practical-Guide/PG_06a_Repetition_Contraint_Patterns.schelp block 0 (part 3/6)
p = Pn(
	Plazy {
		Pbind(
			\degree, Pfin(rrand(3, 10), rrand(-4, 11)),
			\dur, rrand(0.1, 0.4)
		)
	},
	inf
).play;
