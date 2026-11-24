// Source: Classes/BBandStop.schelp block 0 (part 8/9)
(
z = { // nada
BBandStop.ar(
	SinOsc.ar(1000) ! 2,
	1000,
	MouseY.kr(0.0, 10.0, \linear), // bw
	0.5); // mul
}.play)
