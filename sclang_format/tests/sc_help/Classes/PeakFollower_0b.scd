// Source: Classes/PeakFollower.schelp block 0 (part 2/5)
(
{
	SinOsc.ar(
			PeakFollower.ar(Dust.ar(20, Line.kr(0, 1, 4)), 1.0) * 1500 + 200,
			0, 0.2
	)

}.play;
)
