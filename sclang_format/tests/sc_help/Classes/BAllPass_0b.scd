// Source: Classes/BAllPass.schelp block 0 (part 2/5)
(
z = { // thru
BAllPass.ar(
	SoundIn.ar([0, 1]),
	MouseX.kr(10, 18000, \exponential),
	0.8, // rq
	0.5); // mul
}.play)
