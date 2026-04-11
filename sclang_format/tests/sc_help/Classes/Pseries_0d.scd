// Source: Classes/Pseries.schelp block 0 (part 4/4)
(
Pbind(
	\dur, 0.01,
	\instrument, \help_sinegrain,
	\freq, Pseries(800.0, Pbrown(-1.0, 3.0, 0.1, inf), inf)
).play;
)
