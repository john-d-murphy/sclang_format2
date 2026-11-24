// Source: Tutorials/JITLib/recursive_phrasing.schelp block 0 (part 4/45)
(
Pbind(
	\type, \phrase,
	\instrument, Pseq([\sweep, \default, \sweep2, \sweep3, \pgrain, \pgrain], inf),
	\degree, Pseq([0, 3, 2], inf),
	\dur, Pseq([1, 0.5], inf) * 0.7,
	\n, Pseq([4, 6, 25, 10], inf),
	\ratio, Prand([0.03, 0.1, 0.4, -0.1],inf) + Pseq([0, 0, [0, 0.02]], inf),
	\legato, Pseq(#[0.5, 1, 0.5, 0.1, 0.1],inf)
).play;
)
