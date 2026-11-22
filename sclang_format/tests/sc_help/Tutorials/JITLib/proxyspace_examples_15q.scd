// Source: Tutorials/JITLib/proxyspace_examples.schelp block 15 (part 17/17)
(
~out = Pbind(
		\instrument, \who,
		\freq, Pshuf([500, 380, 200, 510, 390, 300, 300],inf) * rrand(1.0, 2.0),
		\legato, 0.1,
		\ffreq, Pshuf([~lfo, 100, ~lfo, 100, 300, 550], inf),
		\dur, 0.125 * [1, 2, 3, 2/3].choose
	);
)
