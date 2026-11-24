// Source: Classes/Gendy1.schelp block 0 (part 11/18)
(
		{
			Pan2.ar(Gendy1.ar(
				maxfreq: Gendy1.kr(5, 4, 0.3, 0.7, 0.1, MouseY.kr(0.1, 10), 1.0, 1.0, 5, 5, 500, 600),
				knum: MouseX.kr(1, 13), mul: 0.2), 0.0)
		}.play
	)
