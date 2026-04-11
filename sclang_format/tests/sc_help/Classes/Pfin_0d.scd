// Source: Classes/Pfin.schelp block 0 (part 4/5)
p = Pbind(
	\instrument, \help_sinegrain,
	\midinote, Pn(Pfin({ rrand(3, 5) }, Pseq([1, 2, 3, 4, 5, 6], inf) * 4 + 65), inf),
	\dur, 0.12
).play;
