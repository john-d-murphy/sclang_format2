// Source: Tutorials/A-Practical-Guide/PG_08_Event_Types_and_Parameters.schelp block 3 (part 2/4)
(
p = Pbind(
	\type, \set,
	\id, a,
	\args, #[\freq],
	\freq, Pexprand(200, 600, inf),
	\dur, Pwhite(1, 5, inf) * 0.125
).play;
)
