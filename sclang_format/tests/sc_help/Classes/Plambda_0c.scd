// Source: Classes/Plambda.schelp block 0 (part 3/4)
(
a = Plambda(
	Pseq([
	Pfindur(5,
		Ppar([
			Pbind(\note, Plet(\x, Prand([1, 5, 1, [10, 14]], inf)), \dur, 8/3, \pan, -1),
			Pbind(\note, Plet(\y, Pseq([5, 3, 2, 0, [0, 5, 6, 9]], inf)), \dur, 0.5, \pan, 1),
			Pbind(\note, Pseq([Pget(\x), Pget(\y)], inf) + 12, \pan, 0, \dur, 2/3)
		])
	),
	Pbind(\note, Pget(\x, 0, 6) + [0, 5], \dur, Pdup(inf, Prand([2/3, 1/6])))
	], inf).trace(\eventScope) // internally, the values are shared via \eventScope
);

b = Pbindf(a, \instrument, \sine, \legato, 0.1);
b.play
)
