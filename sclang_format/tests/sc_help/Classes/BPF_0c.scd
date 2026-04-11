// Source: Classes/BPF.schelp block 0 (part 3/3)
(
{ 	var vib = BPF.kr(PinkNoise.kr, MouseX.kr(1, 100, 1), 0.3) * 10;
	SinOsc.ar(vib * 200 + 600) * 0.2 }.play;
)
