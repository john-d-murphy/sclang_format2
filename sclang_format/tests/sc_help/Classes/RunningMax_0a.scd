// Source: Classes/RunningMax.schelp block 0 (part 1/2)
(
{
	SinOsc.ar(
			RunningMax.ar(Dust.ar(20), Impulse.ar(0.4)) * 500 + 200,
			0, 0.2
	)

}.play;
)
