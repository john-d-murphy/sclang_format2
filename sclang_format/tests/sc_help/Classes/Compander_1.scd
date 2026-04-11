// Source: Classes/Compander.schelp block 1
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

	// apply gate (mouse x sets treshold)
	Compander.ar(z, z,
		thresh: MouseX.kr(0.001, 1),
		slopeBelow: 10,
		slopeAbove:  1,
		clampTime:   0.01,
		relaxTime:   0.01
	)
}.play;
)
