// Source: Classes/BBandPass.schelp block 0 (part 4/5)
(
z = {
BBandPass.ar(
	WhiteNoise.ar ! 2,
	MouseX.kr(20, 20000, \exponential),
	MouseY.kr(0.0, 10.0, \linear), // bw
	0.5); // mul
}.play)
