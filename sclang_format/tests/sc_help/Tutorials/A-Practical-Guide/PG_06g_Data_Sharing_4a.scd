// Source: Tutorials/A-Practical-Guide/PG_06g_Data_Sharing.schelp block 4 (part 1/2)
p = Pbind(
	\z, Pseries(0, 1, inf),
	\a, Pseries(100, -1, inf),
	\b, Pkey(\z) * 2
).asStream;
