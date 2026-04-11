// Source: Classes/BRF.schelp block 0 (part 3/3)
(
{ 	var vib = BRF.kr(SinOsc.kr([1, 3, 10], 0, [1, 0.5, 0.25]).sum, MouseX.kr(1, 10, 1), 0.3);
	SinOsc.ar(vib * 200 + 600) * 0.2 }.play;
)
