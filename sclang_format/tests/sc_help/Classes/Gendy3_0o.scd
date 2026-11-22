// Source: Classes/Gendy3.schelp block 0 (part 15/17)
(
{ Pan2.ar(
	CombN.ar(
		Resonz.ar(
			Gendy3.ar(2, 3, freq: MouseX.kr(10, 700), initCPs: 100),
			MouseY.kr(50, 1000), 0.1
		), 0.1, 0.1, 5, 0.16
	), 0.0
) }.play
)
