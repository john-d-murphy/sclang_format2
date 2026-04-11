// Source: Classes/Hasher.schelp block 0 (part 4/4)
(
{
	SinOsc.ar(
		Hasher.kr(MouseX.kr(0,10), 300, 500)
	) * 0.1
}.play;
)
