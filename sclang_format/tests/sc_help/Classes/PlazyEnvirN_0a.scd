// Source: Classes/PlazyEnvirN.schelp block 0 (part 1/3)
(
f = { |g = 0, h = 0, dur = 1|
	Pbind(\degree, Pseq([g, g, h, g, h], 2), \dur, Pseries(dur, 0.1))
};
// compare:
a = Pchain(PlazyEnvirN(f), (g: [1, 2], h: 3, dur: 0.2)).trace(\degree).asStream;
c = Pchain(Plazy(f), (g: [1, 2], h: 3, dur: 0.2)).asStream;
)
