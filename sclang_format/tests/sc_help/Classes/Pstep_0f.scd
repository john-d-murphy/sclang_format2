// Source: Classes/Pstep.schelp block 0 (part 6/9)
(
var a, b;
a = Pbind(
	\degree, Pstep(Pseq([0, 2b, 3], 1), 1.0),
	\dur, Prand([0.2, 0.5, 1.1, 0.25, 0.15], 9)
);
b = Pbind(
	\degree, Pseq([0, 2b, 3], 1),
	\dur, 2,
	\ctranspose, -7
);

Ppar([a, b], inf).play;
)
