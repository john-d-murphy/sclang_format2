// Source: Classes/BBandStop.schelp block 0 (part 6/9)
(
z = { // drill...
BBandStop.ar(
	SinOsc.ar(1000) ! 2,
	MouseX.kr(800, 1200, \exponential),
	MouseY.kr(0.0, 10.0, \linear), // bw
	0.1); // mul
}.play)
