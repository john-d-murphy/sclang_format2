// Source: Classes/Pspawn.schelp block 2 (part 1/8)
(
p = Pspawn(Pbind(
		// Pbind returned by Pfunc is not embedded, just placed in the event
		// So, it can be spawned
	\pattern, Pfunc { Pbind(\degree, Pseries(rrand(0, 10), #[-1, 1].choose, rrand(4, 10)), \dur, 0.125) },
	\delta, Pwhite(1, 5, inf) * 0.125,
	\method, \par
)).play;
)
