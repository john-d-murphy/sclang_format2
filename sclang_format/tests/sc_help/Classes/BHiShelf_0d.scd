// Source: Classes/BHiShelf.schelp block 0 (part 4/5)
(
z = { // toy around with rs
BHiShelf.ar(
	SoundIn.ar([0,1]),
	MouseX.kr(2200, 18000, \exponential),
	MouseY.kr(0.1, 1.0, \linear), // rs
	6, // db
	0.5); // mul
}.play)
