// Source: Guides/Tour_of_UGens.schelp block 68
(
{
SinOsc.ar(
			PulseCount.ar(Impulse.ar(10), Impulse.ar(0.4)) * 200,
			0, 0.05
		)
}.scope(2, zoom:4);
)
