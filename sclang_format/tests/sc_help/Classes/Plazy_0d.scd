// Source: Classes/Plazy.schelp block 0 (part 4/4)
(
a = Plazy({
	var x, y;
	x = Array.series(rrand(2, 4), [1, 5].choose, 1);
	x.put(x.size.rand, 8+0.1.rand2);
	Pbind(
		\instrument, \help_sinegrain,
		\dur, 0.12,
		\degree, Pseq(x, 2)
	)
});

Pn(a, inf).play;
)
