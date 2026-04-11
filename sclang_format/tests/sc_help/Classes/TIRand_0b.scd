// Source: Classes/TIRand.schelp block 0 (part 2/3)
(
{
	var trig = Dust.kr(10);
	SinOsc.ar(
			TIRand.kr(4, 12, trig) * 100
		) * 0.1
}.play;
)
