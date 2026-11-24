// Source: Classes/NodeProxy.schelp block 21 (part 15/29)
(
b.source = Pbind(
			\instrument, \who,
			\freq, Pseq([600, 350, 300], inf),
			\legato, 0.1,
			\ffreq, Pseq([c, 100, c, 100, 300, 600], inf), // use proxy in a pattern
			\dur, Pseq([1, 0.5, 0.75, 0.25] * 0.4, inf),
			\amp, Pseq([0.2, 0.2, 0.1, 0.1, 0.2], inf)
		);
)
