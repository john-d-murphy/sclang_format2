// Source: Classes/SelectXFocus.schelp block 1
(
{
	var a;
	a = [
			Saw.ar(LFSaw.kr(3 * [1, 1.01], 0, 100, 230)),
			SinOsc.ar,
			Pulse.ar(LFPulse.kr(3 * [1, 1.02], 0, 0.4, 100, 230)),
			SinOsc.ar(SinOsc.kr(4 * [1, 1.03], 0, 200, 300))
		];

	SelectXFocus.ar(MouseX.kr(0, 1) * a.size, a, MouseY.kr(0, a.size)) * 0.2
}.play;
)
