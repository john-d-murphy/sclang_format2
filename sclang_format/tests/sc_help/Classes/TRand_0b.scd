// Source: Classes/TRand.schelp block 0 (part 2/2)
(
{
	var trig = Dust.ar(MouseX.kr(1, 8000, 1));
	SinOsc.ar(
			TRand.ar(300, 3000, trig)
		) * 0.1
}.play;
)
