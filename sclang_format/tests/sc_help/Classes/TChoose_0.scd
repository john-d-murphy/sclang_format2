// Source: Classes/TChoose.schelp block 0
(
{
	var a;
	a = [
			SinOsc.ar,
			Saw.ar,
			Pulse.ar
		];
	TChoose.ar(Dust.ar(MouseX.kr(1, 1000, 1)), a) * 0.2

}.play;
)
