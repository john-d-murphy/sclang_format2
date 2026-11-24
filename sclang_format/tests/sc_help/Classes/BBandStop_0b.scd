// Source: Classes/BBandStop.schelp block 0 (part 2/9)
(
z = {
BBandStop.ar(
	SoundIn.ar([0, 1]),
	MouseX.kr(20, 20000, \exponential),
	MouseY.kr(0.0, 10.0, \linear), // bw
	0.5); // mul
}.play)
