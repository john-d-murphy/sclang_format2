// Source: Classes/PeakFollower.schelp block 0 (part 4/5)
(
{
	var decay;
	decay = MouseX.kr(0.99, 1.00001).min(1.0);
	SinOsc.ar(
			PeakFollower.ar(Dust.ar(20), decay) * 1500 + 200,
			0, 0.2
	);

}.play;
)
