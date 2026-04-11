// Source: Classes/Pnsym.schelp block 0 (part 5/8)
(
Pdef(\play,
	Pbind(
		\instrument, \gpdef,
		\harmonic, Pnsym(Pseq([\x, \x, Prand([\x, \y]), [\z, \y], \y], inf)).trace,
		\dur, 0.2, \note, 10
	)
).play;
)
