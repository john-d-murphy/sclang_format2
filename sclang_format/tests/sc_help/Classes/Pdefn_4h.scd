// Source: Classes/Pdefn.schelp block 4 (part 8/11)
(
Pdefn(\deg, Pseq([0, 3, 2], inf));

Pset(\instrument, \Pdefhelp,
	Ppar([
		Pbind(\degree, Pdefn(\deg), \pan, -0.8),
		Pbind(\degree, Pdefn(\deg), \dur, 1/3, \pan, 0.8)
])
).play;
)
