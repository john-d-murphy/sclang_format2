// Source: Classes/RunningMax.schelp block 0 (part 2/2)
(
{
	SinOsc.ar(
			RunningMax.kr(SinOsc.kr(0.2), Impulse.kr(MouseX.kr(0.01, 2, 1))) * 500 + 200,
			0, 0.2
	)

}.play;
)
