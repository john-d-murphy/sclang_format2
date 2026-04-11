// Source: Classes/BPeakEQ.schelp block 0 (part 4/5)
(
z = { // toy with rq
BPeakEQ.ar(
	SoundIn.ar([0,1]),
	MouseX.kr(20, 20000, \exponential),
	MouseY.kr(10, 0.4, \linear), // rq
	6, // boost/cut - +6dB
	0.5); // mul
}.play)
