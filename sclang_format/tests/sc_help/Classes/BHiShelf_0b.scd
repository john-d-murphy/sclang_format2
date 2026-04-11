// Source: Classes/BHiShelf.schelp block 0 (part 2/5)
(
z = { // toy around with boost/cut
BHiShelf.ar(
	SoundIn.ar([0,1]),
	MouseX.kr(2200, 18000, \exponential),
	1.0, // rs
	MouseY.kr(18.0, -18.0, \linear),
	0.5); // mul
}.play)
