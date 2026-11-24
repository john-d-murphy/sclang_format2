// Source: Classes/Gendy1.schelp block 0 (part 16/18)
(
		{
			var n = 10;
			Mix.fill(n, {
				var freq, numcps;

				freq = rrand(130, 160.3);
				numcps = rrand(2, 20);
				Pan2.ar(
					Gendy1.ar(
						6.rand, 6.rand, 1.0.rand, 1.0.rand, freq, freq, 1.0.rand, 1.0.rand, numcps,
						SinOsc.kr(exprand(0.02, 0.2), 0, numcps/2, numcps/2), 0.5 / (n.sqrt)
					),
					1.0.rand2
				)
			})
		}.play
	)
