// Source: Classes/TBall.schelp block 0 (part 2/5)
(
{
	var t, sf, g;
	sf = LFNoise0.ar(MouseX.kr(0.5, 100, 1));
	g = MouseY.kr(0.01, 10, 1);
	t = TBall.ar(sf, g, 0.01, 0.002);
	Ringz.ar(t * 4, [600, 645], 0.3);
}.play;
)
