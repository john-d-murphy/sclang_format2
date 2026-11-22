// Source: Tutorials/A-Practical-Guide/PG_02_Basic_Vocabulary.schelp block 10
(
p = Pbind(
	\degree, Ppatlace([
		Pseries(0, 1, 8),	// first, third etc. notes
		Pseries(2, 1, 7)	// second, fourth etc. notes
	], inf),
	\dur, 0.25
).play;
)
