// Source: Classes/Pseed.schelp block 1 (part 19/20)
(
Pdef(\drumPat,
	Pseed(9223372036854775807, // This is the highest 64 bit number.
		Psync(
			Pbind(*[
				instrument: \drum,
				tun: Pstutter(Plprand(4, 8), Plprand(0.0, 8.0).round(1/8)),
				amp: Plprand(-7.5.dbamp, -1.5.dbamp),
				dur: 1 / Pstutter(Phprand(5, 11), Pwhite(5, 11)),
				legato: Plprand(0.75, 4.0),
				pan: Prand([Phprand(0.0, 0.5, 1), Plprand(0.5, 1.0, 1)], inf),
				// pew: 0.4,
				// pew: Phprand(0.4, 10.0),
			]), 1, 2.0, // Loop length is the second number here.
		)
	)
).play(quant: 1);
)
