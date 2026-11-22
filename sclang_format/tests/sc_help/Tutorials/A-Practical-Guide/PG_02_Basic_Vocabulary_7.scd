// Source: Tutorials/A-Practical-Guide/PG_02_Basic_Vocabulary.schelp block 7
(
p = Pbind(
	\degree, Pwrand((0..7), [4, 1, 3, 1, 3, 2, 1].normalizeSum, inf),
	\dur, 0.25
).play;
)
