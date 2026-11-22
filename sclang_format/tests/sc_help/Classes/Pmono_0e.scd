// Source: Classes/Pmono.schelp block 0 (part 5/6)
(
p = Pfindur(5,
	Pset(\detune, Pwhite(0, 1.0) * [0, 1, 3, 7],
		Ppar([
			Pmono(\default, \dur, 0.2, \freq, Pwhite(1, 8) * 100),
			Pmono(\default, \dur, 0.1, \freq, Pwhite(1, 8) * 300)
		])
	)
).play;
)
