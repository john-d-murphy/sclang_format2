// Source: Tutorials/A-Practical-Guide/PG_05_Math_on_Patterns.schelp block 8 (part 1/2)
(
p = Pbind(
	\degree, Pseries(4, Pwhite(-2, 2, inf).reject({ |x| x == 0 }), inf).fold(-7, 11),
	\dur, Prorate(0.6, 0.5)	// actually yields 0.3, 0.2, 0.3, 0.2...
).play;
)
