// Source: Tutorials/A-Practical-Guide/PG_Cookbook02_Manipulating_Patterns.schelp block 4 (part 1/4)
(
Pdefn(\degree, Pn(Pseries(0, 1, 8), inf));
Pdefn(\dur, Pn(0.25, inf));

p = Pbind(
	\degree, Pdefn(\degree),
	\dur, Pdefn(\dur)
).play;
)
