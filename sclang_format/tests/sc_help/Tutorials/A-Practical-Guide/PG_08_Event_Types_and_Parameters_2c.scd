// Source: Tutorials/A-Practical-Guide/PG_08_Event_Types_and_Parameters.schelp block 2 (part 3/5)
(
p = Pbind(
	\type, \set,
	\id, a,
	\instrument, \event_set,
	\args, #[],
	\freq, Pexprand(200, 600, inf),
	\dur, Pwhite(1, 5, inf) * 0.125
).play;
)
