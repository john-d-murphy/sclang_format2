// Source: Classes/BLowShelf.schelp block 0 (part 4/5)
(
z = { // toy around with rs
BLowShelf.ar(
	SoundIn.ar([0,1]),
	MouseX.kr(20, 6000, \exponential),
	MouseY.kr(0.1, 1.0, \linear), // rs
	6,
	0.5); // mul
}.play)
