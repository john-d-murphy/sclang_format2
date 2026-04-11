// Source: Classes/Ball.schelp block 0
(
{
	var f, sf;
	sf = K2A.ar(MouseX.kr > 0.5) > 0;
	f = Ball.ar(sf, MouseY.kr(0.01, 20, 1), 0.01);
	f = f * 10 + 500;
	SinOsc.ar(f, 0, 0.2)
}.play;
)
