// Source: Tutorials/A-Practical-Guide/PG_03_What_Is_Pbind.schelp block 1 (part 1/6)
(
p = Pbind(
	\degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
	\dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).asStream;	// remember, you have to make a stream out of the pattern before using it
)
