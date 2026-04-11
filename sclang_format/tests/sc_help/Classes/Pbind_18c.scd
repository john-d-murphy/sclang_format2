// Source: Classes/Pbind.schelp block 18 (part 3/3)
(
f.stream = Pbind(
	\degree, Pseq([0, 1, 2, 4, 6, 3, 4, 8], inf),
	\dur, 0.5, \octave, [2, 1],
	\instrument, \berlinb,
	\pan, Pfunc({1.0.rand2})
).asStream;
)
