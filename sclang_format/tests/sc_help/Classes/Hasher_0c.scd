// Source: Classes/Hasher.schelp block 0 (part 3/4)
(
{
	SinOsc.ar(
		Hasher.kr(MouseX.kr(0,10).round(1) + 0.0001, 300, 500)
	) * 0.1
}.play;
)
