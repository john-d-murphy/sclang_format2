// Source: Classes/Gendy2.schelp block 1 (part 16/18)
(
{ 
	Pan2.ar(
		CombN.ar(
			Resonz.ar(
				Gendy2.ar(2, 3, minfreq: 1, maxfreq: MouseX.kr(10, 700), initCPs: 100),
				MouseY.kr(50, 1000), 0.1
			),		
			0.1, 0.1, 5, 0.16
		),
		0.0
	)
}.play
)
