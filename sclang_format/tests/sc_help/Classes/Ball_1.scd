// Source: Classes/Ball.schelp block 1
(
{
	var f, sf, g;
	sf = LFNoise0.ar(MouseX.kr(1, 100, 1));
	g = MouseY.kr(0.1, 10, 1);
	f = Ball.ar(sf, g, 0.01, 0.01);
	f = f * 140 + 500;
	SinOsc.ar(f, 0, 0.2)
}.play;
)
