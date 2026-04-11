// Source: Classes/BPeakEQ.schelp block 0 (part 2/5)
(
z = { // toy with boost/cut
BPeakEQ.ar(
	SoundIn.ar([0,1]),
	MouseX.kr(20, 20000, \exponential),
	0.8, // rq
	MouseY.kr(12.0, -12.0, \linear),
	0.5); // mul
}.play)
