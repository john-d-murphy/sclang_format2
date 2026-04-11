// Source: Classes/EventPatternProxy.schelp block 3 (part 19/26)
(
x = Ppar([
	Pbindf(Pn(a, inf),
		\gtranspose, Pdup(8, Pseq(#[0, 2, 0, 3],inf))
	),
	Pbindf(Pn(a, inf),
		\gtranspose, Pdup(8, Pseq(#[7, 4, 0, 3],inf)),
		\dur, 0.6
	),
	Pbindf(Pn(a, inf),
		\degree, Pseq(#[0, 5, 4, 3, 2, 3, 2], 1)
	)
]).play;
)
