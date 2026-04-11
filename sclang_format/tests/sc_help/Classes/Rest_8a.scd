// Source: Classes/Rest.schelp block 8 (part 1/2)
(
p = Pbind(
	\degree, Pseries(0, 1, inf).fold(-7, 7),
	\dur, 0.125,
	\type, Pwrand([\note, \rest], [0.9, 0.1], inf)
).play;
)
