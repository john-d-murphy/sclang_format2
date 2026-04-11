// Source: Classes/TExpRand.schelp block 0 (part 1/2)
(
{
	var trig = Dust.kr(10);
	SinOsc.ar(
			TExpRand.kr(300.0, 3000.0, trig)
		) * 0.1
}.play;
)
