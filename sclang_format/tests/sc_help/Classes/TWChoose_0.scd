// Source: Classes/TWChoose.schelp block 0
(
{
	var a;
	a = [
			SinOsc.ar,
			Saw.ar,
			Pulse.ar
		];
	TWChoose.ar(Dust.ar(MouseX.kr(1, 1000, 1)), a, [0.99, 0.05, 0.05].normalizeSum) * 0.2

}.play;
)
