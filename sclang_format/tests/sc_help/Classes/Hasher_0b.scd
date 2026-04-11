// Source: Classes/Hasher.schelp block 0 (part 2/4)
(
{
	SinOsc.ar(
		Hasher.kr(MouseX.kr(0,10).round(1), 300, 500)
	) * 0.1
}.play;
)
