// Source: Classes/Pgate.schelp block 0
(
Pbind(
	\degree, Pseq((0..7), inf),
	\step, Pseq([false, false, false, true, false, true, false], inf),
	\octave, Pgate(Pwhite(3, 7), inf, \step),
	\dur, 0.2
).play
)
