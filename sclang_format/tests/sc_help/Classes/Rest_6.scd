// Source: Classes/Rest.schelp block 6
(
Pbind(
	\degree, Pseries(0, 1, inf).fold(-7, 7),
	\dur, Pseq([Pn(0.125, { rrand(3, 6) }), Rest(0.25)], inf)
).play
)
