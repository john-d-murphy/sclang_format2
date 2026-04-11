// Source: Tutorials/A-Practical-Guide/PG_Cookbook03_External_Control.schelp block 1 (part 2/4)
(
p = Pbind(
	\degree, Pwhite(-7, 12, inf),
	\dur, Pwrand([0.25, Pn(0.125, 2)], #[0.8, 0.2], inf),
	\legato, ~legato
).play;
)
