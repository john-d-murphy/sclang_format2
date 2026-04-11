// Source: Classes/TRand.schelp block 0 (part 1/2)
(
{
	var trig = Dust.kr(10);
	SinOsc.ar(
			TRand.kr(300, 3000, trig)
		) * 0.1
}.play;
)
