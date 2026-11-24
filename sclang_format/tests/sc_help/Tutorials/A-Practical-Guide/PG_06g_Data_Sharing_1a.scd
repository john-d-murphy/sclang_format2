// Source: Tutorials/A-Practical-Guide/PG_06g_Data_Sharing.schelp block 1 (part 1/2)
(
p = Pbind(
	\degree, Pseq([Pseries(-7, 1, 14), Pseries(7, -1, 14)], inf),
	\dur, 0.25,
		// \degree is EARLIER in the Pbind
	\legato, Pkey(\degree).linexp(-7, 7, 2.0, 0.05)
).play;
)
