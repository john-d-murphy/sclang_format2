// Source: Classes/TExpRand.schelp block 0 (part 2/2)
(
{
	var trig = Dust.ar(MouseX.kr(1, 8000, 1));
	SinOsc.ar(
			TExpRand.ar(300.0, 3000.0, trig)
		) * 0.1
}.play;
)
