// Source: Classes/Pgpar.schelp block 0 (part 3/3)
(
var p, q, r, o;
Pbus(
	Pgpar([
		Pbind(\degree, Prand((0..7), inf), \dur, 0.3, \legato, 0.2),
		Pbind(\instrument, \echo, \dur, 3, \legato, 1.1,
			\dtime, Pwhite(0.01, 0.1, inf), \decay, 3),
		Pbind(\instrument, \distort, \dur, 1.2, \legato, 1.1,
			\pregain, Pwhite(1, 20, inf), \amp, 0.25),
		Pbind(\instrument, \wah, \dur, 4.0, \legato, 1.1,
			\rate, Pwhite(0.1, 3, inf))
	])
).play
)
