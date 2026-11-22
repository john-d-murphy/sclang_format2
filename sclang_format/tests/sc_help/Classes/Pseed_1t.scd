// Source: Classes/Pseed.schelp block 1 (part 20/20)
(
Pdef(\varsawPat,
	Pbind(*[
		instrument: \varsaw,
		attack: Plprand(0.01, 1.0),
		release: Pwrand([0.5, 8], [8, 1].normalizeSum, inf),
		dur: 1 / Pseed(490, Pstutter(Phprand(5, 11), Plprand(5, 11))), // Pseed used on a single parameter.
		amp: Plprand(-18.dbamp, -12.dbamp),
		freq: 100 * Plprand(1, 9),
		width: Plprand(0.0, 0.5),
		cutoff: Phprand(20, 5500),
		pan: -1,
	])
).play(quant: 1);

Pdef(\drumPat,
	Pbind(*[
		instrument: \drum,
		tun: Pstutter(Plprand(4, 8), Plprand(0.0, 8.0).round(1/8)),
		fed: Plprand(0.0, 1.0),
		amp: Plprand(-18.dbamp, -12.dbamp),
		dur: 1 / Pseed(490, Pstutter(Phprand(5, 11), Plprand(5, 11))), // Same seed, same rhythm.
		legato: Plprand(0.75, 4.0),
		pan: 1,
	])
).play(quant: 1);
)
