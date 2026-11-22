// Source: Classes/Gendy3.schelp block 0 (part 12/17)
(
{ Pan2.ar(
	Gendy3.ar(1, 2, freq: Gendy2.ar(maxfreq: Gendy1.kr(5, 4, 0.3, 0.7, 0.1, MouseY.kr(0.1, 10), 1.0, 1.0, 5, 5, 25, 26), minfreq: 24, knum: MouseX.kr(1, 13), mul: 150, add: 200), durscale: 0.01, ampscale: 0.01, mul: 0.1), 
	0.0) 
}.play
)
