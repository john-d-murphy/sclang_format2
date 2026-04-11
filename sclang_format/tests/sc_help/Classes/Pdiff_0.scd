// Source: Classes/Pdiff.schelp block 0
p = Pbind(
	\degree, Pxrand([0,2,3,4,6,7],12),
	\dur, Pdiff(Pkey(\degree)).abs/4,
).play;
