// Source: Tutorials/JITLib/proxyspace_examples.schelp block 15 (part 9/17)
(
~out = Pbind(
		\instrument, \who,
		\freq, Pseq([500, 380, 300],inf),
		\legato, 0.1,
		\ffreq, Pseq([~lfo, 100, ~lfo, 100, 300, 550], inf), // use it in a pattern
		\dur, Pseq([1, 0.5, 0.75, 0.125]*0.4, inf)
	);
)
