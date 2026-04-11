// Source: Classes/Ptime.schelp block 0 (part 6/7)
(
var a, b;
a = Pbind(
	\degree, Pswitch(#[0, 2b, 3], Ptime(8).round(2) / 2),
	\dur, Prand(#[0.2, 0.5, 1.1, 0.25, 0.15], inf)
);
b = Pbind(
	\degree, Pseq(#[0, 2b, 3], 1),
	\dur, 2,
	\ctranspose, -7
);
Pseq([Event.silent(1.25), Ppar([a, b])], inf).play;
)
