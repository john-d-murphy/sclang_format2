// Source: Classes/BBandPass.schelp block 0 (part 2/5)
(
z = {
BBandPass.ar(
	SoundIn.ar([0,1]),
	MouseX.kr(20, 20000, \exponential),
	MouseY.kr(0.0, 10.0, \linear), // bw
	0.5); // mul
}.play)
