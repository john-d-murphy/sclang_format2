// Source: Tutorials/A-Practical-Guide/PG_Cookbook02_Manipulating_Patterns.schelp block 3 (part 1/4)
(
~degree = PatternProxy(Pn(Pseries(0, 1, 8), inf));
~dur = PatternProxy(Pn(0.25, inf));

p = Pbind(
	\degree, ~degree,
	\dur, ~dur
).play;
)
