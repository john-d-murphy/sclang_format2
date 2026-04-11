// Source: Classes/TBall.schelp block 0 (part 3/5)
(
{
	var f, g, h, fr;
	fr = MouseX.kr(1, 1000, 1);
	h = MouseY.kr(0.0001, 0.001, 1);
	g = LFNoise1.kr(0.1, 3, 5);
	f = TBall.ar(SinOsc.ar(fr), g, 0.1, h);
	Pan2.ar(Ringz.ar(f, 1400, 0.04),0,5)
}.play;
)
