// Source: Classes/Pbind.schelp block 16 (part 3/6)
(
Pdef(\buckyball, Pbind(\instrument, \acid, \dur, Pseq([0.25, 0.5, 0.25], inf), \root, [-24, -17],
	\degree, Pseq([0b, 3b, 5b, 7b, 9b, 11b, 5b, 0b], inf), \pan, Pfunc({1.0.rand2}), //notice the flats
	\cut, Pxrand([1000, 500, 2000, 300], inf), \rez, Pfunc({0.7.rand +0.3}), \amp, 0.2));
)
