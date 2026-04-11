// Source: Classes/PeakFollower.schelp block 0 (part 5/5)
(
{
	var decay;
	decay = MouseX.kr(0, 1.1).min(1.0);
	SinOsc.ar(
			PeakFollower.kr(SinOsc.kr(0.2), decay) * 200 + 500,
			0, 0.2
	)

}.play;
)
