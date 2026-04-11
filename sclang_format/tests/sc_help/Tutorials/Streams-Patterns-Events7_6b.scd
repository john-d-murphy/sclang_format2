// Source: Tutorials/Streams-Patterns-Events7.schelp block 6 (part 2/3)
(
// you can change the stream at any point in time
e.stream = Pbind(
	\degree, Pseq([0,1,2,4,6,3,4,8],inf),
	\dur, Prand([0.2,0.4,0.8],inf),
	\amp, 0.05,
	\octave, 5,
	\instrument, \help_SPE7_BerlinB, // you can also use a symbol
	\ctranspose, 0
).asStream;
)
