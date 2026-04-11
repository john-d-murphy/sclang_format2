// Source: Classes/Pbind.schelp block 8 (part 2/2)
(
Pbind(\instrument, \acid, \dur, Pseq([0.25, 0.5, 0.25], inf), \root, -12,
	\degree, Pseq([0, 3, 5, 7, 9, 11, 5, 1], inf), \pan, Pfunc({1.0.rand2}),
	\cut, Pxrand([1000, 500, 2000, 300], inf), \rez, Pfunc({0.7.rand +0.3}), \amp, 0.2).play;
)
