// Source: Classes/Psync.schelp block 0 (part 2/8)
(
// a fixed duration pattern:

f = Pbind(
	\dur, 0.5,
	\degree, Pn(4,1),
	\instrument, \help_sinegrain
);

// this pattern has indetermined length:
a = Prand([
	Pbind(
		\dur, Pseq([0.02, 0.002, 0.1, 0.1],2),
		\degree, Pseq([9, 7, 5],inf),
		\instrument, \help_sinegrain
	),
	Pbind(
		\dur, Pseq([1, 0.35],2),
		\degree, Pseq([0, [2b,5b]],inf),
		\instrument, \help_sinegrain
	),
	Pbind(
		\dur, Pseq([0.15, 0.25, 1.3],2),
		\degree, Pseq([2b,4,5b],inf),
		\instrument, \help_sinegrain
	)
]);
)
