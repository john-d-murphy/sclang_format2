// Source: Classes/BLowPass4.schelp block 0 (part 2/3)
(
z = {
	BLowPass4.ar(
		SoundIn.ar([0,1]),
		MouseX.kr(10, 20000, \exponential), // cutoff freq.
		MouseY.kr(0.1, 1.0, \linear), // rq - compensate for 2 biquad sections.
		0.5); // mul
}.play)
