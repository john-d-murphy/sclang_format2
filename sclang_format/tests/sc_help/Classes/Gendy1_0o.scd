// Source: Classes/Gendy1.schelp block 0 (part 15/18)
(
		{
			Pan2.ar(
				CombN.ar(
					Resonz.ar(
						Gendy1.ar(2, 3, minfreq: 1, maxfreq: MouseX.kr(10, 700), durscale: 0.1, initCPs: 10),
						MouseY.kr(50, 1000), 0.1),
					0.1, 0.1, 5, 0.6
				),
				0.0)
		}.play
	)
