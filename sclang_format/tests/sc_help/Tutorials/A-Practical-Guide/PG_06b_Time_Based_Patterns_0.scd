// Source: Tutorials/A-Practical-Guide/PG_06b_Time_Based_Patterns.schelp block 0
(
p = Pbind(
	\degree, Pif(Ptime(inf) < 4.0, Pwhite(-4, 11, inf)),
	\dur, 0.25
).play;
)
