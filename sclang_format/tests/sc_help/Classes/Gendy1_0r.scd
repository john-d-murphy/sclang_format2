// Source: Classes/Gendy1.schelp block 0 (part 18/18)
(
		{
			var n = 15;


			Resonz.ar(
				Mix.fill(n, {
					var freq, numcps;

					freq = rrand(330, 460.3);
					numcps = rrand(2, 20);
					Pan2.ar(
						Gendy1.ar(
							6.rand, 6.rand, 1.0.rand, 1.0.rand, freq,
							MouseX.kr(freq, 2*freq), 1.0.rand, 1.0.rand, numcps,
							SinOsc.kr(exprand(0.02, 0.2), 0, numcps/2, numcps/2), 0.5/(n.sqrt)
						),
						1.0.rand2
					)
				}),
				MouseX.kr(100, 2000), MouseY.kr(0.01, 1.0)
			)

		}.play;
	)
