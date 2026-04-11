// Source: Tutorials/A-Practical-Guide/PG_08_Event_Types_and_Parameters.schelp block 0
Pbind(
	\curve, Pseg(Pseq([0, 1, 0], 1), 15),
	\degree, Pwhite(-7, 0, inf) + Pkey(\curve).linlin(0, 1, 0, 14).asInteger,
	\dur, 0.5,
	\tempo, Pkey(\curve).linlin(0, 1, 1, 10)
).play;
