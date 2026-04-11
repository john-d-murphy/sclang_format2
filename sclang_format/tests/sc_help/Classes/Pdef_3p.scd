// Source: Classes/Pdef.schelp block 3 (part 16/26)
(
x = Ppar([
	Pbindf(Pn(Pdef(\a), inf),
		\gtranspose, Pdup(8, Pseq(#[0, 2, 0, 3],inf))
	),
	Pbindf(Pn(Pdef(\a), inf),
		\gtranspose, Pdup(8, Pseq(#[7, 4, 0, 3],inf)),
		\dur, 0.6
	),
	Pbindf(Pn(Pdef(\a), inf),
		\degree, Pseq(#[0, 5, 4, 3, 2, 3, 2], 1)
	)
]).play;
)
