// Source: Classes/Pseed.schelp block 1 (part 17/20)
(
Pdef(\varsawPat,
	Pseed(490, // This number is the seed.
		Pbind(*[
			instrument: \varsaw,
			attack: Plprand(0.01, 1.0),
			release: Pwrand([0.5, 8], [8, 1].normalizeSum, inf),
			dur: 1 / Pstutter(Phprand(5, 11), Plprand(5, 11)),
			freq: 100 * Plprand(1, 9),
			width: Phprand(0.0, 0.5),
			cutoff: Phprand(20, 5500),
			pan: Pmeanrand(-1.0, 1.0),
		])
	)
).play
)
