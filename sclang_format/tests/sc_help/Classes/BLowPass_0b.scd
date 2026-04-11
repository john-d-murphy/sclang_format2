// Source: Classes/BLowPass.schelp block 0 (part 2/3)
(
z = {
	BLowPass.ar(
		SoundIn.ar([0,1]),
		MouseX.kr(10, 20000, \exponential), // cutoff freq.
		MouseY.kr(0.0, 1.0, \linear), // rq
		0.5); // mul
}.play
)
