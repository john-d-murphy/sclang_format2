// Source: Classes/TIRand.schelp block 0 (part 3/3)
(
{
	var trig = Dust.ar(MouseX.kr(1, 8000, 1));
	SinOsc.ar(
			TIRand.ar(4, 12, trig) * 100
		) * 0.1
}.play;
)
