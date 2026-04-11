// Source: Classes/Compander.schelp block 2
(
{
	var z;

	// signal (clean)
	z = Decay2.ar(
		Impulse.ar(8, 0, LFSaw.kr(0.3, 1, -0.3, 0.3)),
		0.001,
		0.3
	)
	* Mix.ar(Pulse.ar([80, 81], 0.3));

	// apply compression  (mouse x sets amount)
	Compander.ar(z, z,
		thresh: MouseX.kr(0.01, 1),
		slopeBelow: 1,
		slopeAbove: 0.5,
		clampTime:  0.01,
		relaxTime:  0.01
	)
}.play;
)
