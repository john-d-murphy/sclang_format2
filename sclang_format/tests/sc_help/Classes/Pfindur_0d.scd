// Source: Classes/Pfindur.schelp block 0 (part 4/4)
(
var c;
c = Pbind(
	\dur, Prand([1, 0.02, 0.2], inf),
	\instrument, \help_sinegrain,
	\degree, Pseries(0, 1, inf),
	\octave, 6
);

Pn(
	Pfindur(1, c)
).play;
)
