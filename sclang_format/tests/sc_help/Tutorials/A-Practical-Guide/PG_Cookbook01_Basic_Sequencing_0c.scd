// Source: Tutorials/A-Practical-Guide/PG_Cookbook01_Basic_Sequencing.schelp block 0 (part 3/3)
(
p = Pbind(
	\scale, #[0, 2, 3, 5, 7, 8, 10],
	\root, 2,
	\degree, Ppatlace([Pseq(#[rest, 3, 2, 1, 0, -0.9, 0, 1, 2, -3, -1.9, -0.9, 0, -0.9, 0, 1, 2], 1),
		Pn(4, 16)], inf),
	\dur, 0.25
).play;
)
