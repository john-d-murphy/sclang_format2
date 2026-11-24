// Source: Classes/Pdup.schelp block 1 (part 3/10)
(
a = Pbind(
	\instrument, \help_sinegrain,
	\note, Pxrand([0, 5, 7, 9], inf),
	\dur, 0.05,
	\sustain, 0.1
);
Pdup(Pseq([1, 2, 3, 4], inf), a).trace.play;
)
