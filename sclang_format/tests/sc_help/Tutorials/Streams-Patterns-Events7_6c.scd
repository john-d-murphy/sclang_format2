// Source: Tutorials/Streams-Patterns-Events7.schelp block 6 (part 3/3)
(
e.stream = Pbind(
	[\degree, \dur], Pseq(
		[
			Pseq([[0,0.1],[2,0.1],[3,0.1],[4,0.1],[5,0.8]],2),
			Ptuple([Pxrand([6,7,8,9],4), 0.4]),
			Ptuple([Pseq([9,8,7,6,5,4,3,2]), 0.2])
		], inf
	),
	\amp, 0.05,
	\octave, 5,
	\instrument, \help_SPE7_CFString1
).asStream;
)
