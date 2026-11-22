// Source: Tutorials/A-Practical-Guide/PG_06a_Repetition_Contraint_Patterns.schelp block 1 (part 3/4)
p = Pn(Pfindur(4, Pbind(
	\degree, Pseq([-7, Pwhite(0, 11, inf)], 1),
	\dur, Pwhite(1, 4, inf) * 0.25
)), inf).play;
