// Source: Classes/Pindex.schelp block 0 (part 2/2)
(
var data = [7, 13, 12, 2, 2, 2, 5];
var indices = [0, 0, 2, 0, 4, 6, 7];
Pbind(
	\instrument, \help_pindex,
	\choice, Prand(indices, inf),
	\degree, Pindex(data, Pkey(\choice), inf),
	\dur, 0.7
).play
)
