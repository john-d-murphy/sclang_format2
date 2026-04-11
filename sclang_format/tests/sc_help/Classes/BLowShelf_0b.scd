// Source: Classes/BLowShelf.schelp block 0 (part 2/5)
(
z = { // toy around with boost/cut
BLowShelf.ar(
	SoundIn.ar([0,1]),
	MouseX.kr(40, 6000, \exponential),
	1.0, // rs
	MouseY.kr(24.0, -24.0, \linear),
	0.5); // mul
}.play)
