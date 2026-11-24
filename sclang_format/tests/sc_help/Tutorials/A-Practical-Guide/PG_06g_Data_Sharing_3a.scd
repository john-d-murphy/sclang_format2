// Source: Tutorials/A-Practical-Guide/PG_06g_Data_Sharing.schelp block 3 (part 1/2)
p = Plambda(
	Pbind(
		\a, Plet(\z, Pseries(0, 1, inf), Pseries(100, -1, inf)),
		\b, Pget(\z, 0, inf) * 2
	).trace(key: \eventScope, prefix: "\nscope: ")
).asStream;
