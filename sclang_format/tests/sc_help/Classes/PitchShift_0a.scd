// Source: Classes/PitchShift.schelp block 0 (part 1/3)
(
play({
	z = Blip.ar(800, 6, 0.1);
	PitchShift.ar(z, 0.02, Line.kr(0.1,4,20), 0, 0.0001)
}))
