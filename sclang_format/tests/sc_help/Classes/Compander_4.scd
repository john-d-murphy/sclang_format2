// Source: Classes/Compander.schelp block 4
(
// note the pops at the beginning of signal due to lack of lookahead
{
	var z;

	// signal (clean)
	z = Decay2.ar(
		Impulse.ar(8, 0, LFSaw.kr(0.3, 1, -0.3, 0.3)),
		0.001,
		0.3
	)
	* Mix.ar(Pulse.ar([80, 81], 0.3));

	// apply sustainer
	Compander.ar(z, z,
		thresh: MouseX.kr(0.1, 1),
		slopeBelow: 0.1,
		slopeAbove: 1,
		clampTime:  0.01,
		relaxTime:  0.01
	) * 0.1
}.play;
)
