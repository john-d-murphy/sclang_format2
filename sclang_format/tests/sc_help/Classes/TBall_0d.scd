// Source: Classes/TBall.schelp block 0 (part 4/5)
(
{
	var f, g, h, fr;
	fr = LinExp.kr(SinOsc.kr(0.1), -1, 1, 1, 600);
	h = MouseY.kr(0.0001, 0.001, 1);
	g = MouseX.kr(1, 10);
	f = TBall.ar(SinOsc.ar(fr), g, 0.1, h);
	Pan2.ar(Ringz.ar(f, 1400, 0.04),0,5)
}.play;
)
