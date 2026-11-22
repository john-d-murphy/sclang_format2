// Source: Classes/Pkey.schelp block 0 (part 8/11)
p = Pbind(
	\a, Pseries(1, 1, inf),
	\b, Pif(
		Pkey(\a) == 2,
		"equals 2",
		"nope"
	)
).asStream;
