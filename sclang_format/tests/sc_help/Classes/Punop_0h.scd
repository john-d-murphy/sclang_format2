// Source: Classes/Punop.schelp block 0 (part 8/10)
(
Pbind(
	\dur, 0.01,
	\instrument, \help_sinegrain,
	\note, Pn(Punop(\sqrt, Pseries(0, 1, 12)))
).play;
)
