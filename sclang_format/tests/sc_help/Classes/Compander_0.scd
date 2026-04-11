// Source: Classes/Compander.schelp block 0
(
{
	Decay2.ar(
		Impulse.ar(8, 0, LFSaw.kr(0.3, 1, -0.3, 0.3)),
		0.001,
		0.3
	)
	* Mix.ar(Pulse.ar([80, 81], 0.3))
}.play;
)
