// Source: Classes/Pbind.schelp block 7 (part 1/3)
(
e.stream = Pbind(
	\degree, Pseq([0, 1, 2, 4, 6, 3, 4, 8], inf),
	\dur, Prand([0.2, 0.4, 0.8], inf),
	\amp, 0.05, \octave, 5,
	\instrument, \cfstring1, \ctranspose, 0
).asStream;
)
