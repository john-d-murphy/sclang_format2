// Source: Classes/RunningMin.schelp block 0 (part 1/2)
(
{
	SinOsc.ar(
			RunningMin.ar(Dust.ar(20), Impulse.ar(0.4)) * 500 + 200,
			0, 0.2
	)

}.play;
)
