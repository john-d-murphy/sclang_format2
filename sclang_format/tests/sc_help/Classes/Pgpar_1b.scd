// Source: Classes/Pgpar.schelp block 1 (part 2/2)
(
x = Pbind(
	\instrument, \help_sinegrain,
	\degree, Pn(Plazy({ Prand([0, 4, 5], 16) + 5.rand })) + Prand(#[0, [0, 3], [0, 7]], inf),
	\dur, Prand([0.25, 0.5, 1.0], inf),
	\scale, #[0, 3, 5, 9, 10]
);
y = Pbind(
	\instrument, \gap,
	\dur, Prand([0.25, 0.5, 1.0], inf) * Pdup(inf, Prand([0.25, 1, 2],1)),
	\legato, Prand([0.25, 0.5, 1.0], inf),
	\leak, 0.25
);
a = Pbus(Pgpar([x, y, x, y, x, y]));
a.play;
)
