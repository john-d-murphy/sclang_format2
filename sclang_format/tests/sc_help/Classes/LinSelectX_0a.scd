// Source: Classes/LinSelectX.schelp block 0 (part 1/2)
(
{
	var a;
	a = [
			SinOsc.ar,
			Saw.ar(300),
			Pulse.ar(230)
		];

	LinSelectX.ar(MouseX.kr(0, 1) * a.size, a) * 0.2
}.play;
)
