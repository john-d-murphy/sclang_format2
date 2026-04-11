// Source: Classes/SelectX.schelp block 0 (part 2/2)
(
{
	var a;
	a = [
			SinOsc.kr(0.25),
			LFSaw.kr(10),
			LFPulse.kr(0.3)
		];

	SinOsc.ar(SelectX.kr(MouseX.kr(0, 1) * a.size, a) * 300 + 400) * 0.2
}.play;
)
