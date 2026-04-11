// Source: Classes/Pluck.schelp block 0 (part 2/4)
(
	{Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(2), 440.reciprocal, 440.reciprocal, 10,
		coef:MouseX.kr(-0.999, 0.999))
	}.play(s)
)
