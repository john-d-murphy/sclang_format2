// Source: Classes/PatternProxy.schelp block 3 (part 2/8)
(
x = PatternProxy.new;
x.source = Pseq([0, 3, 2], inf);

Pset(\instrument, \Pdefhelp,
	Ppar([
	Pbind(\degree, x),
	Pbind(\degree, x, \dur, 1/3)
])
).play;
)
