// Source: Tutorials/A-Practical-Guide/PG_02_Basic_Vocabulary.schelp block 11
(
p = Pbind(
	\degree, Ptuple([
		Pseries(7, -1, 8),
		Pseq([9, 7, 7, 7, 4, 4, 2, 2], 1),
		Pseq([4, 4, 4, 2, 2, 0, 0, -3], 1)
	], 1),
	\dur, 1
).play;
)
