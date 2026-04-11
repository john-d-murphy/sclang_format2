// Source: Tutorials/A-Practical-Guide/PG_02_Basic_Vocabulary.schelp block 3 (part 3/3)
(
p = Pbind(
	\degree, Pslide((-6, -4 .. 12), 8, 3, 1, 0),
	\dur, Pseq(#[0.1, 0.1, 0.2], inf),
	\sustain, 0.15
).play;
)
