// Source: Classes/Ball.schelp block 2
(
{
	var f, sf, g;
	sf = LFPulse.ar(0.6, 0.2, 0.5);
	g = MouseY.kr(0.1, 10, 1);
	d = MouseX.kr(0.0001, 1, 1);
	f = Ball.ar(sf, g, d);
	f = f * 140 + 400;
	SinOsc.ar(f, 0, 0.2)
}.play;
)
